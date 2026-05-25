class AppException implements Exception {
  final String message;
  final int? statusCode;
  const AppException(this.message, {this.statusCode});

  @override
  String toString() => 'AppException($statusCode): $message';
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error. Please check your connection.']);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Session expired. Please sign in again.'])
      : super(statusCode: 401);
}

class ForbiddenException extends AppException {
  const ForbiddenException([super.message = 'You do not have permission to perform this action.'])
      : super(statusCode: 403);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found.']) : super(statusCode: 404);
}

class ValidationException extends AppException {
  const ValidationException(super.message) : super(statusCode: 400);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error. Please try again later.'])
      : super(statusCode: 500);
}
