import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/api_interceptor.dart';
import 'package:revexa/core/storage/secure_storage.dart';

class DioClient {
  DioClient._();
  static final DioClient instance = DioClient._();

  late final Dio _dio;
  bool _initialized = false;

  void init({void Function()? onUnauthorized}) {
    if (_initialized) return;

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.addAll([
      // Auth + headers come first so the token is attached before retry.
      ApiInterceptor(
        SecureStorage.instance,
        onUnauthorized: onUnauthorized,
      ),
      // Retry network errors and timeouts up to 2 extra times with backoff.
      _RetryInterceptor(_dio),
      if (kDebugMode)
        LogInterceptor(
          request: false,
          requestHeader: false,
          responseHeader: false,
          logPrint: (obj) => debugPrint('[DIO] $obj'),
        ),
    ]);

    _initialized = true;
  }

  Dio get dio {
    assert(
      _initialized,
      'DioClient must be initialized before use. '
      'Call DioClient.instance.init() in ServiceLocator.',
    );
    return _dio;
  }
}

// ─── Retry Interceptor ────────────────────────────────────────────────────────

/// Retries requests that fail with network / timeout errors.
/// Does NOT retry on 4xx/5xx HTTP responses — those are deterministic.
class _RetryInterceptor extends Interceptor {
  final Dio _dio;

  static const _maxRetries = 2;

  _RetryInterceptor(this._dio);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final shouldRetry = _isRetryable(err.type);
    final attempt = (err.requestOptions.extra['_retryCount'] as int?) ?? 0;

    if (shouldRetry && attempt < _maxRetries) {
      // Exponential backoff: 300ms, 600ms, …
      final delay = Duration(milliseconds: 300 * pow(2, attempt).toInt());
      await Future<void>.delayed(delay);

      final options = err.requestOptions
        ..extra['_retryCount'] = attempt + 1;

      try {
        final response = await _dio.fetch<dynamic>(options);
        handler.resolve(response);
      } on DioException catch (retryErr) {
        handler.next(retryErr);
      }
      return;
    }

    handler.next(err);
  }

  bool _isRetryable(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return false;
    }
  }
}
