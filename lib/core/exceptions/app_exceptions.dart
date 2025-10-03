abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException(String message, {String? code}) : super(message, code: code);
}

class AuthenticationException extends AppException {
  const AuthenticationException(String message, {String? code}) : super(message, code: code);
}

class NetworkException extends AppException {
  const NetworkException(String message, {String? code}) : super(message, code: code);
}

class ValidationException extends AppException {
  const ValidationException(String message, {String? code}) : super(message, code: code);
}

class CacheException extends AppException {
  const CacheException(String message, {String? code}) : super(message, code: code);
}

class PermissionException extends AppException {
  const PermissionException(String message, {String? code}) : super(message, code: code);
}