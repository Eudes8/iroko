# 📱 Intégration Flutter APK avec Backend Node.js

Guide pour connecter votre application Flutter à ce backend Node.js/PostgreSQL.

## 🎯 Architecture

```
APK Flutter
    ↓
HTTP REST API (http_service.dart)
    ↓
Node.js/Express Backend
    ↓
PostgreSQL Database
```

## ⚙️ Configuration Flutter

### 1. Mettre à jour les constantes

Éditer `lib/core/constants/app_constants.dart`:

```dart
class AppConstants {
  // API Backend
  static const String baseUrl = 'https://iroko-backend.railway.app/api/v1';
  
  // Ou en développement:
  // static const String baseUrl = 'http://192.168.1.100:3000/api/v1';
  // static const String baseUrl = 'http://10.0.2.2:3000/api/v1'; // Android emulator
  
  // JWT
  static const String storageKeyAuthToken = 'auth_token';
  static const String storageKeyUserId = 'user_id';
  static const String storageKeyUserEmail = 'user_email';
  static const String storageKeyUserRole = 'user_role';
}
```

### 2. Mettre à jour HTTP Service

Éditer `lib/core/services/http_service.dart`:

```dart
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  final Dio _dio;
  final SharedPreferences _prefs;

  HttpService({
    required Dio dio,
    required SharedPreferences prefs,
  })  : _dio = dio,
        _prefs = prefs {
    _setupDio();
  }

  void _setupDio() {
    _dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
      contentType: 'application/json',
    );

    _dio.interceptors.add(_AuthInterceptor(_prefs));
  }

  // GET API call
  Future<T> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      return response.data as T;
    } catch (e) {
      rethrow;
    }
  }

  // POST API call
  Future<T> post<T>(
    String path, {
    required data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data as T;
    } catch (e) {
      rethrow;
    }
  }

  // Idem pour PATCH, PUT, DELETE...
}

// Interceptor pour ajouter le token
class _AuthInterceptor extends Interceptor {
  final SharedPreferences _prefs;

  _AuthInterceptor(this._prefs);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _prefs.getString(AppConstants.storageKeyAuthToken);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token expiré ou invalide
      _prefs.remove(AppConstants.storageKeyAuthToken);
      // Rediriger vers login
    }
    handler.next(err);
  }
}
```

### 3. Créer AuthProvider pour gérer l'authentification

Créer `lib/presentation/providers/auth_provider.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iroko/core/services/http_service.dart';

class AuthProvider with ChangeNotifier {
  final HttpService _httpService;
  final SharedPreferences _prefs;

  String? _token;
  String? _userId;
  String? _userRole;

  AuthProvider(this._httpService, this._prefs) {
    _loadStoredToken();
  }

  String? get token => _token;
  String? get userId => _userId;
  String? get userRole => _userRole;
  bool get isAuthenticated => _token != null;

  void _loadStoredToken() {
    _token = _prefs.getString(AppConstants.storageKeyAuthToken);
    _userId = _prefs.getString(AppConstants.storageKeyUserId);
    _userRole = _prefs.getString(AppConstants.storageKeyUserRole);
  }

  // SIGNUP
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String role, // 'client' ou 'provider'
    String? phone,
  }) async {
    try {
      final response = await _httpService.post('/auth/sign-up', data: {
        'email': email,
        'password': password,
        'name': name,
        'role': role,
        'phone': phone,
      });

      final token = response['data']['token'];
      final userId = response['data']['user']['id'];
      final userRole = response['data']['user']['role'];

      // Sauvegarder token
      await _prefs.setString(AppConstants.storageKeyAuthToken, token);
      await _prefs.setString(AppConstants.storageKeyUserId, userId);
      await _prefs.setString(AppConstants.storageKeyUserRole, userRole);
      await _prefs.setString(AppConstants.storageKeyUserEmail, email);

      _token = token;
      _userId = userId;
      _userRole = userRole;

      notifyListeners();
    } catch (error) {
      throw Exception('Signup failed: $error');
    }
  }

  // LOGIN
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _httpService.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final token = response['data']['token'];
      final userId = response['data']['user']['id'];
      final userRole = response['data']['user']['role'];

      // Sauvegarder
      await _prefs.setString(AppConstants.storageKeyAuthToken, token);
      await _prefs.setString(AppConstants.storageKeyUserId, userId);
      await _prefs.setString(AppConstants.storageKeyUserRole, userRole);
      await _prefs.setString(AppConstants.storageKeyUserEmail, email);

      _token = token;
      _userId = userId;
      _userRole = userRole;

      notifyListeners();
    } catch (error) {
      throw Exception('Login failed: $error');
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _prefs.remove(AppConstants.storageKeyAuthToken);
    await _prefs.remove(AppConstants.storageKeyUserId);
    await _prefs.remove(AppConstants.storageKeyUserRole);
    await _prefs.remove(AppConstants.storageKeyUserEmail);

    _token = null;
    _userId = null;
    _userRole = null;

    notifyListeners();
  }
}
```

### 4. Utiliser dans les écrans

Exemple dans `lib/presentation/auth/login_screen.dart`:

```dart
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Se connecter')),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'exemple@test.com',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);

    try {
      await Provider.of<AuthProvider>(context, listen: false).login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Navigation après login réussi
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $error')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

## 🧪 Tester l'API

### Via Postman

1. **Signup**
   ```
   POST http://localhost:3000/api/v1/auth/sign-up
   
   Body (JSON):
   {
     "email": "test@test.com",
     "password": "password123",
     "name": "Test User",
     "role": "client"
   }
   ```

2. **Login**
   ```
   POST http://localhost:3000/api/v1/auth/login
   
   Body:
   {
     "email": "test@test.com",
     "password": "password123"
   }
   
   Response:
   {
     "success": true,
     "data": {
       "token": "eyJhbGciOiJIUzI1NiIs...",
       "user": { ... }
     }
   }
   ```

3. **Use Token**
   ```
   GET http://localhost:3000/api/v1/missions
   
   Headers:
   Authorization: Bearer <token_from_login>
   ```

### Via cURL

```bash
# Signup
curl -X POST http://localhost:3000/api/v1/auth/sign-up \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@test.com",
    "password": "password123",
    "name": "Test User",
    "role": "client"
  }'

# Login
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@test.com",
    "password": "password123"
  }'

# Get missions (with token)
curl -X GET http://localhost:3000/api/v1/missions \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## 🚀 APK Build

### Debug APK (Test)

```bash
# Build APK
flutter build apk

# Installer sur phone
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

### Release APK (Production)

```bash
# Créer keystore (une seule fois)
keytool -genkey -v -keystore ~/.android/iroko.jks -keyalg RSA -keysize 2048 -validity 10000 -alias iroko_key

# Build release APK
flutter build apk --release

# Installer
adb install build/app/outputs/flutter-apk/app-release.apk

# Ou build bundle (pour Google Play)
flutter build appbundle --release
```

### Signer APK pour Google Play

Créer `android/key.properties`:
```properties
storePassword=votre_password
keyPassword=votre_password
keyAlias=iroko_key
storeFile=/path/to/iroko.jks
```

## 🔧 Configuration pour différents environnements

### Development (Émulateur)
```dart
static const String baseUrl = 'http://10.0.2.2:3000/api/v1';
```

### Development (Device réel sur même réseau)
```dart
static const String baseUrl = 'http://192.168.1.100:3000/api/v1';
```

### Staging
```dart
static const String baseUrl = 'https://staging-api.iroko.ci/api/v1';
```

### Production
```dart
static const String baseUrl = 'https://api.iroko.ci/api/v1';
```

Utiliser build flavors pour automatiser:

```bash
# Flavor development
flutter run --flavor development -t lib/main_development.dart

# Flavor production
flutter run --flavor production -t lib/main_production.dart
```

## 📝 Checklist avant publication

- [ ] Backend URL pointant vers production
- [ ] JWT tokens persisted et restored
- [ ] Error handling pour 401/403
- [ ] Offline mode avec cache Hive si nécessaire
- [ ] Images uploadées vers AWS S3
- [ ] Payments intégrés (Stripe)
- [ ] Push notifications configurées
- [ ] Tests d'intégration passés
- [ ] APK signée avec release key
- [ ] Prêt pour Google Play Store submission

---

**Status**: ✅ Production Ready
**Last Updated**: 2024-02-10
