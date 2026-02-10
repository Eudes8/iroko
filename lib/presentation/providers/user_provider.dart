import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:iroko/core/utils/exceptions.dart';
import 'package:iroko/domain/entities/user.dart';
import 'package:iroko/domain/usecases/auth_usecases.dart';

class UserProvider extends ChangeNotifier {
  final _getIt = GetIt.instance;
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasUser => _user != null;

  // Get current user info
  Future<void> loadUserProfile() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final useCase = await _getIt.getAsync<GetCurrentUserUseCase>();
      _user = await useCase.call(const NoParams());
      _isLoading = false;
      notifyListeners();
    } on AppException catch (e) {
      _isLoading = false;
      _errorMessage = e.message;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erreur lors du chargement du profil';
      notifyListeners();
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    String? name,
    String? phone,
    String? location,
    String? bio,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final data = <String, dynamic>{
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (location != null) 'location': location,
        if (bio != null) 'bio': bio,
        if (additionalData != null) ...additionalData,
      };

      final useCase = await _getIt.getAsync<UpdateProfileUseCase>();
      final updateParams = UpdateProfileParams(data: data);
      _user = await useCase.call(updateParams);
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
      _errorMessage = 'Erreur lors de la mise à jour';
      notifyListeners();
      return false;
    }
  }

  // Clear user data
  void clearUser() {
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
