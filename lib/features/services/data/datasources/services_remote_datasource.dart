import 'package:dio/dio.dart';
import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/features/services/data/models/service_model.dart';

abstract interface class ServicesRemoteDataSource {
  Future<ServicesPage> getAllServices({int page = 1, int limit = 10});
  Future<Service> getServiceById(String id);
  Future<List<Service>> getServicesByCategory(String category);
}

class ServicesRemoteDataSourceImpl implements ServicesRemoteDataSource {
  final Dio _dio;
  ServicesRemoteDataSourceImpl() : _dio = DioClient.instance.dio;

  @override
  Future<ServicesPage> getAllServices({int page = 1, int limit = 10}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.services,
        queryParameters: {'page': page, 'limit': limit},
      );
      final data = response.data['data'] as List<dynamic>;
      final pagination = response.data['pagination'] as Map<String, dynamic>? ?? {};

      return ServicesPage(
        services: data.map((e) => Service.fromJson(e as Map<String, dynamic>)).toList(),
        totalServices: (pagination['totalServices'] as num?)?.toInt() ?? 0,
        totalPages: (pagination['totalPages'] as num?)?.toInt() ?? 1,
        currentPage: (pagination['currentPage'] as num?)?.toInt() ?? page,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<Service> getServiceById(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.serviceById(id));
      return Service.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<List<Service>> getServicesByCategory(String category) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.services,
        queryParameters: {'category': category},
      );
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => Service.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}
