# Code Style Guide et Bonnes Pratiques - IROKO

## 📐 Conventions de nommage

### Fichiers
```dart
// snake_case pour les fichiers
lib/presentation/auth/login_screen.dart        ✅
lib/data/models/user_model.dart                ✅
lib/domain/usecases/auth_usecases.dart         ✅

// PAS de majuscules au début
lib/presentation/auth/LoginScreen.dart         ❌
```

### Classes et Types
```dart
// PascalCase pour les classes
class UserModel { }                            ✅
class LoginUseCase { }                         ✅
class AuthRepository { }                       ✅

// PAS de `I` au début pour interfaces
abstract class UserRepository { }              ✅
abstract class IUserRepository { }             ❌
```

### Variables et Fonctions
```dart
// camelCase pour variables et fonctions
final userEmail = 'user@example.com';         ✅
final _isLoading = false;                     ✅
void handleLogin() { }                        ✅

// PAS de préfixes inutiles
final m_userEmail = 'user@example.com';       ❌
final user_email = 'user@example.com';        ❌
```

### Constantes
```dart
// camelCase pour les constantes (même privées)
const defaultTimeout = 30000;                 ✅
const _buttonRadius = 8.0;                    ✅

// PAS d'ALL_CAPS sauf variables compilées
const DEFAULT_TIMEOUT = 30000;                ❌ (sauf cas spéciaux)
```

## 📦 Structure des fichiers

### Les dossiers doivent être organisés par feature, pas par type

```
// ✅ BON - Organisé par feature
lib/
├── presentation/
│   ├── auth/           # Feature complète: écrans, widgets
│   ├── home/
│   ├── profile/
│   └── widgets/        # Widgets partagés
├── data/
├── domain/
└── core/

// ❌ MAUVAIS - Organisé par type
lib/
├── screens/
├── widgets/
├── models/
├── repositories/
└── services/
```

## 🎨 Code Style

### Imports
```dart
// Ordre: dart → flutter → packages → relative
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import 'service.dart';
```

### Linting
```bash
# Analyser le code
flutter analyze

# Formater le code
dart format lib/

# Utiliser la configuration analysis_options.yaml
```

## 🎯 Bonnes pratiques

### 1. Utiliser const quand possible
```dart
// ✅ BON
const CircleAvatar(
  radius: 50,
  child: Icon(Icons.person),
)

// ❌ MAUVAIS
CircleAvatar(
  radius: 50,
  child: Icon(Icons.person),
)
```

### 2. Utiliser GetIt pour l'injection de dépendances
```dart
// ✅ BON - Dans main.dart
GetIt.I.registerSingleton<LoginUseCase>(
  LoginUseCase(GetIt.I<AuthRepository>()),
);

// Puis utiliser partout
final loginUseCase = GetIt.I<LoginUseCase>();

// ❌ MAUVAIS - Instance manuelle
final authRepository = AuthRepository();
final loginUseCase = LoginUseCase(authRepository);
```

### 3. Toujours fournir de la documentation
```dart
// ✅ BON
/// Valide un email selon le format RFC 5322.
///
/// Retourne true si l'email est valide, false sinon.
/// 
/// Example:
/// ```dart
/// isValidEmail('user@example.com') // true
/// ```
bool isValidEmail(String email) {
  return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
}

// ❌ MAUVAIS
bool validateEmail(String email) {
  return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
}
```

### 4. Gestion d'état avec Provider
```dart
// ✅ BON - Utiliser Provider
class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _loginUseCase(LoginParams(email, password));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  bool get isLoading => _isLoading;
}

// Dans le widget
Consumer<AuthProvider>(
  builder: (_, auth, __) {
    if (auth.isLoading) return CircularProgressIndicator();
    return Text('Login');
  },
)
```

### 5. Gérer les exceptions correctement
```dart
// ✅ BON
try {
  final user = await loginUseCase(params);
  setState(() => _user = user);
} on AuthenticationException catch (e) {
  _showSnackBar('Email ou mot de passe incorrect');
} on NetworkException catch (e) {
  _showSnackBar('Erreur de connexion réseau');
} on AppException catch (e) {
  _showSnackBar('Une erreur est survenue: ${e.message}');
}

// ❌ MAUVAIS
try {
  final user = await loginUseCase(params);
  setState(() => _user = user);
} catch (e) {
  print(e);  // Ne pas imprimer les erreurs
}
```

### 6. Utiliser des noms de variables explicites
```dart
// ✅ BON
final isUserLoggedIn = currentUser != null;
final shouldShowLoadingIndicator = isLoading && !hasError;

// ❌ MAUVAIS
final x = currentUser != null;
final show = isLoading && !hasError;
```

### 7. Paramètres nommés obligatoires
```dart
// ✅ BON
class User {
  const User({
    required this.id,
    required this.email,
    this.phone,  // optionnel
  });
}

// ❌ MAUVAIS
class User {
  const User(this.id, this.email, [this.phone]);
}
```

### 8. Utiliser des extensions pour du code lisible
```dart
// ✅ BON
extension StringExtensions on String {
  bool get isValidEmail => contains('@');
  String get capitalized => isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
}

// Utilisation
'john'.capitalized  // "John"
'user@email.com'.isValidEmail  // true
```

## 🧪 Tests

### Structure des tests
```dart
// test/domain/usecases/login_usecase_test.dart
void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  group('LoginUseCase', () {
    test('devrait retourner un User quand la connexion réussit', () async {
      // Arrange
      final params = LoginParams(email: 'test@test.com', password: 'pass');
      final expectedUser = User(id: '1', email: 'test@test.com');
      
      when(mockAuthRepository.login('test@test.com', 'pass'))
          .thenAnswer((_) async => expectedUser);

      // Act
      final result = await loginUseCase(params);

      // Assert
      expect(result, expectedUser);
      verify(mockAuthRepository.login('test@test.com', 'pass')).called(1);
    });
  });
}
```

## 📋 Checklist avant le commit

- [ ] Code formaté avec `dart format`
- [ ] Pas d'erreurs avec `flutter analyze`
- [ ] Tests unitaires passent
- [ ] Pas de code en dur (hardcoded values)
- [ ] Pas de debug prints
- [ ] Pas de dépendances circulaires
- [ ] Documentation complète
- [ ] Noms de variables explicites
- [ ] Pas de fichiers temporaires

## 🚫 Anti-patterns à éviter

### 1. Exposer les détails d'implémentation
```dart
// ❌ MAUVAIS
class UserRepository {
  List<UserModel> _users = [];
  List<UserModel> get users => _users;  // Expose l'implémentation
}

// ✅ BON
class UserRepository {
  List<UserModel> _users = [];
  Future<List<User>> getUsers() async { /* ... */ }
}
```

### 2. God Objects / Classes énormes
```dart
// ❌ MAUVAIS - Une seule classe fait tout
class UserService {
  void login() { }
  void register() { }
  void updateProfile() { }
  void calculateStats() { }
  void sendNotification() { }
  // ... 50 autres méthodes
}

// ✅ BON - Séparer les responsabilités
class AuthService { }
class UserService { }
class NotificationService { }
```

### 3. Utiliser les getters pour des opérations coûteuses
```dart
// ❌ MAUVAIS
get userCount {
  return database.query('SELECT COUNT(*) FROM users');  // Appel async!
}

// ✅ BON
Future<int> getUserCount() async {
  return await database.query('SELECT COUNT(*) FROM users');
}
```

## 🔍 Performance

### 1. Utiliser `const` pour les constructeurs
```dart
// ✅ BON
const AppBar(title: const Text('Home'))

// ❌ MAUVAIS
AppBar(title: Text('Home'))
```

### 2. Ne pas reconstruire les widgets inutilement
```dart
// ✅ BON
class MyWidget extends StatefulWidget {
  const MyWidget({required this.data});
  final String data;
  
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

// ❌ MAUVAIS
class MyWidget extends StatelessWidget {
  final String data;
  // Reconstruit à chaque fois
}
```

### 3. Utiliser `ListView.builder` pour les listes
```dart
// ✅ BON - Lazy loading
ListView.builder(
  itemCount: 1000,
  itemBuilder: (_, i) => ListTile(title: Text('Item $i')),
)

// ❌ MAUVAIS - Charge tout en mémoire
ListView(
  children: List.generate(1000, (i) => ListTile(title: Text('Item $i'))),
)
```

## 📝 Commits

### Message de commit clair
```
// ✅ BON
feat: implémenter l'écran de connexion
fix: corriger l'erreur de validation d'email
refactor: extraire le service HTTP
docs: ajouter la documentation API

// ❌ MAUVAIS
fixed stuff
update
WIP
changes
```

## 🎯 Résumé

1. **Lisibilité first** - Le code doit être facile à lire
2. **Single Responsibility** - Une classe = une responsabilité
3. **DRY (Don't Repeat Yourself)**
4. **SOLID Principles** - Respecter les principes SOLID
5. **Tests** - Écrire des tests unitaires
6. **Documentation** - Documenter le code non évident

---

Pour plus d'aide, consultez:
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart)
- [Flutter Best Practices](https://flutter.dev/docs/testing/best-practices)
- [Clean Code](https://www.oreilly.com/library/view/clean-code-a/9780136083238/)
