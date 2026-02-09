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
  ServerException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class NetworkException extends AppException {
  NetworkException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class CacheException extends AppException {
  CacheException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class ValidationException extends AppException {
  final Map<String, String>? errors;

  ValidationException({
    required String message,
    String? code,
    this.errors,
  }) : super(message: message, code: code);
}

class AuthenticationException extends AppException {
  AuthenticationException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class AuthorizationException extends AppException {
  AuthorizationException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class NotFoundException extends AppException {
  NotFoundException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class ConflictException extends AppException {
  ConflictException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}
