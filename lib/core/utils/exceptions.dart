abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException({
    required this.message,
    this.code,
  });

  @override
  String toString() => message;
}

class ServerException extends AppException {
  ServerException({required super.message, super.code});
}

class NetworkException extends AppException {
  NetworkException({required super.message, super.code});
}

class CacheException extends AppException {
  CacheException({required super.message, super.code});
}

class ValidationException extends AppException {
  final Map<String, String>? errors;

  ValidationException({
    required super.message,
    super.code,
    this.errors,
  });
}

class AuthenticationException extends AppException {
  AuthenticationException({required super.message, super.code});
}

class AuthorizationException extends AppException {
  AuthorizationException({required super.message, super.code});
}

class NotFoundException extends AppException {
  NotFoundException({required super.message, super.code});
}

class ConflictException extends AppException {
  ConflictException({required super.message, super.code});
}
