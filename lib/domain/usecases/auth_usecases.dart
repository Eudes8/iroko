import 'package:iroko/data/repositories/auth_repository.dart';
import 'package:iroko/domain/entities/user.dart';

abstract class UseCase<T, Params> {
  Future<T> call(Params params);
}

class NoParams {
  const NoParams();
}

// Login UseCase
class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<User> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({
    required this.email,
    required this.password,
  });
}

// Register UseCase
class RegisterUseCase implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<User> call(RegisterParams params) async {
    return await repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
      role: params.role,
    );
  }
}

class RegisterParams {
  final String email;
  final String password;
  final String name;
  final String role;

  RegisterParams({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
  });
}

// GetCurrentUser UseCase
class GetCurrentUserUseCase implements UseCase<User?, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<User?> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}

// Logout UseCase
class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<void> call(NoParams params) async {
    return await repository.logout();
  }
}

// Update Profile UseCase
class UpdateProfileUseCase implements UseCase<User, UpdateProfileParams> {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<User> call(UpdateProfileParams params) async {
    return await repository.updateProfile(params.data);
  }
}

class UpdateProfileParams {
  final Map<String, dynamic> data;

  UpdateProfileParams({required this.data});
}

// Reset Password UseCase
class ResetPasswordUseCase implements UseCase<void, String> {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<void> call(String email) async {
    return await repository.resetPassword(email);
  }
}
