import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:iroko/core/utils/exceptions.dart';
import 'package:iroko/domain/entities/user.dart';
import 'package:iroko/domain/usecases/auth_usecases.dart';

class AuthProvider extends ChangeNotifier {
  final _getIt = GetIt.instance;
  
  User? _currentUser;
  String? _authToken;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  // Getters
  User? get currentUser => _currentUser;
  String? get authToken => _authToken;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  // Login
  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final loginUseCase = await _getIt.getAsync<LoginUseCase>();
      _currentUser = await loginUseCase(LoginParams(email: email, password: password));
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _isLoading = false;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Une erreur est survenue';
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final registerUseCase = await _getIt.getAsync<RegisterUseCase>();
      _currentUser = await registerUseCase(
        RegisterParams(
          email: email,
          password: password,
          name: name,
          role: role,
        ),
      );
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _isLoading = false;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erreur lors de l\'inscription';
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      final logoutUseCase = await _getIt.getAsync<LogoutUseCase>();
      await logoutUseCase(const NoParams());
      
      _currentUser = null;
      _authToken = null;
      _isAuthenticated = false;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get current user
  Future<void> getCurrentUser() async {
    try {
      final useCase = await _getIt.getAsync<GetCurrentUserUseCase>();
      _currentUser = await useCase(const NoParams());
      _isAuthenticated = _currentUser != null;
      notifyListeners();
    } catch (e) {
      _currentUser = null;
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  // Update profile
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      notifyListeners();

      final useCase = await _getIt.getAsync<UpdateProfileUseCase>();
      _currentUser = await useCase(UpdateProfileParams(data: data));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erreur lors de la mise à jour du profil';
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
