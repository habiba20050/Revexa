import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:revexa/core/error/exceptions.dart';
import 'package:revexa/core/error/failures.dart';

class ErrorHandler {
  ErrorHandler._();

  /// Converts a DioException into an AppException
  static AppException handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        if (kIsWeb) {
          return const NetworkException(
            'Unable to reach the server. Check your internet connection and try again.',
          );
        }
        return const NetworkException('No internet connection. Please check your network.');
      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);
      case DioExceptionType.cancel:
        return const AppException('Request was cancelled.');
      default:
        return const NetworkException();
    }
  }

  static AppException _handleResponseError(Response? response) {
    if (response == null) return const ServerException();
    final message = _extractMessage(response.data);
    switch (response.statusCode) {
      case 400:
        return ValidationException(message);
      case 401:
        return const UnauthorizedException();
      case 403:
        return ForbiddenException(message);
      case 404:
        return NotFoundException(message);
      case 409:
        return ValidationException(message);
      case 500:
      case 502:
      case 503:
        return ServerException(message);
      default:
        return AppException(message, statusCode: response.statusCode);
    }
  }

  static String _extractMessage(dynamic data) {
    if (data == null) return 'Unknown error occurred.';
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? data['error']?.toString() ?? 'Unknown error occurred.';
    }
    final text = data.toString();
    if (text.contains('<!DOCTYPE') || text.contains('<html')) {
      final match = RegExp(r'<pre>([^<]+)</pre>', caseSensitive: false).firstMatch(text);
      if (match != null) return match.group(1)!.trim();
      if (text.contains('Cannot GET')) {
        return 'API route not found on the server. Check that the backend is running.';
      }
      return 'Server returned an unexpected response.';
    }
    if (text.length > 200) return '${text.substring(0, 200)}...';
    return text;
  }

  /// Converts any exception into a Failure
  static Failure toFailure(Object error) {
    if (error is DioException) {
      final appEx = handleDioError(error);
      return _appExceptionToFailure(appEx);
    }
    if (error is AppException) {
      return _appExceptionToFailure(error);
    }
    return UnknownFailure(error.toString());
  }

  static Failure _appExceptionToFailure(AppException ex) {
    if (ex is NetworkException) return NetworkFailure(ex.message);
    if (ex is UnauthorizedException) return AuthFailure(ex.message);
    if (ex is ForbiddenException) return ServerFailure(ex.message, statusCode: 403);
    if (ex is NotFoundException) return NotFoundFailure(ex.message);
    if (ex is ValidationException) return ValidationFailure(ex.message);
    if (ex is ServerException) return ServerFailure(ex.message, statusCode: 500);
    return UnknownFailure(ex.message);
  }
}
