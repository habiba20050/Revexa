import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:revexa/core/storage/secure_storage.dart';

class ApiInterceptor extends Interceptor {
  final SecureStorage _storage;
  final void Function()? onUnauthorized;

  ApiInterceptor(this._storage, {this.onUnauthorized});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Attach Bearer token when available.
    final token = await _storage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Let Dio set the multipart boundary automatically for file uploads.
    if (options.data is FormData) {
      options.headers.remove('Content-Type');
    } else {
      options.headers['Content-Type'] ??= 'application/json';
    }

    options.headers['Accept'] = 'application/json';

    if (kDebugMode) {
      debugPrint(
        '[API] --> ${options.method} ${options.uri}',
      );
      // Print request headers and body to aid debugging (dev only)
      try {
        debugPrint('[API] headers: ${options.headers}');
        debugPrint('[API] body: ${options.data}');
      } catch (_) {}
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '[API] <-- ${response.statusCode} ${response.requestOptions.uri}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '[API] ERROR ${err.response?.statusCode} ${err.requestOptions.uri}: '
        '${err.message}',
      );
      try {
        debugPrint('[API] error response data: ${err.response?.data}');
      } catch (_) {}
    }

    if (err.response?.statusCode == 401) {
      // Clear token and notify the app to redirect to sign-in.
      _storage.clearAll();
      onUnauthorized?.call();
    }

    handler.next(err);
  }
}
