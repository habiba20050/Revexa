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
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );
    _dio.interceptors.addAll([
      ApiInterceptor(
        SecureStorage.instance,
        onUnauthorized: onUnauthorized,
      ),
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
    assert(_initialized, 'DioClient must be initialized before use. Call DioClient.instance.init()');
    return _dio;
  }
}

