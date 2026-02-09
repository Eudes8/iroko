import 'package:iroko/core/services/http_service.dart';
import 'package:iroko/core/utils/exceptions.dart';
import 'package:iroko/data/models/user_model.dart';
import 'package:iroko/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register({
    required String email,
    required String password,
    required String name,
    required String role, // 'client' ou 'provider'
  });
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<User> updateProfile(Map<String, dynamic> data);
  Future<void> resetPassword(String email);
  Future<void> verifyEmail(String token);
}

class AuthRepositoryImpl implements AuthRepository {
  final HttpService _httpService;
  final SharedPreferences _prefs;

  AuthRepositoryImpl({
    required HttpService httpService,
    required SharedPreferences prefs,
  })  : _httpService = httpService,
        _prefs = prefs;

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _httpService.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final authResponse = AuthResponse.fromJson(response);
      
      // Save token and user data
      await _httpService.saveAuthToken(authResponse.accessToken);
      await _prefs.setString('user_id', authResponse.user.id);
      await _prefs.setString('user_email', authResponse.user.email);
      await _prefs.setString('user_role', authResponse.user.role);

      return authResponse.user;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Erreur lors de la connexion',
        code: 'LOGIN_FAILED',
      );
    }
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      final response = await _httpService.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'name': name,
          'role': role,
        },
      );

      final authResponse = AuthResponse.fromJson(response);
      
      // Save token and user data
      await _httpService.saveAuthToken(authResponse.accessToken);
      await _prefs.setString('user_id', authResponse.user.id);
      await _prefs.setString('user_email', authResponse.user.email);
      await _prefs.setString('user_role', authResponse.user.role);

      return authResponse.user;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Erreur lors de l\'inscription',
        code: 'REGISTER_FAILED',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _httpService.post<Map<String, dynamic>>(
        '/auth/logout',
        data: {},
      );
      
      await _httpService.clearAuthToken();
      await _prefs.remove('user_id');
      await _prefs.remove('user_email');
      await _prefs.remove('user_role');
    } catch (e) {
      // Still clear local data even if logout fails
      await _httpService.clearAuthToken();
      await _prefs.remove('user_id');
      await _prefs.remove('user_email');
      await _prefs.remove('user_role');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final token = _httpService.getAuthToken();
      if (token == null) return null;

      final response = await _httpService.get<Map<String, dynamic>>(
        '/auth/me',
      );

      return UserModel.fromJson(response);
    } catch (e) {
      await logout();
      return null;
    }
  }

  @override
  Future<User> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _httpService.put<Map<String, dynamic>>(
        '/auth/profile',
        data: data,
      );

      return UserModel.fromJson(response);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Erreur lors de la mise à jour du profil',
        code: 'UPDATE_PROFILE_FAILED',
      );
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _httpService.post<Map<String, dynamic>>(
        '/auth/reset-password',
        data: {
          'email': email,
        },
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Erreur lors de la demande de réinitialisation',
        code: 'RESET_PASSWORD_FAILED',
      );
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    try {
      await _httpService.post<Map<String, dynamic>>(
        '/auth/verify-email',
        data: {
          'token': token,
        },
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Erreur lors de la vérification de l\'email',
        code: 'VERIFY_EMAIL_FAILED',
      );
    }
  }
}
