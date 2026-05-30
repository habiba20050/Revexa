import 'package:dio/dio.dart';
import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/features/products/data/models/product_model.dart';
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
    // Vercel backend exposes catalog on /products (not /services).
    try {
      return await _fetchProductsAsServices(page: page, limit: limit);
    } on DioException catch (productsError) {
      try {
        return await _fetchServicesEndpoint(page: page, limit: limit);
      } on DioException catch (_) {
        throw ErrorHandler.handleDioError(productsError);
      }
    }
  }

  @override
  Future<Service> getServiceById(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.productById(id));
      final data = _unwrapData(response.data);
      return _serviceFromJson(data);
    } on DioException catch (_) {
      try {
        final response = await _dio.get(ApiEndpoints.serviceById(id));
        final data = _unwrapData(response.data);
        return _serviceFromJson(data);
      } on DioException catch (e) {
        throw ErrorHandler.handleDioError(e);
      }
    }
  }

  @override
  Future<List<Service>> getServicesByCategory(String category) async {
    final page = await getAllServices(limit: 100);
    return page.services
        .where((s) => s.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  Future<ServicesPage> _fetchProductsAsServices({required int page, required int limit}) async {
    final response = await _dio.get(
      ApiEndpoints.products,
      queryParameters: {'page': page, 'limit': limit},
    );
    return _pageFromResponse(response.data);
  }

  Future<ServicesPage> _fetchServicesEndpoint({required int page, required int limit}) async {
    final response = await _dio.get(
      ApiEndpoints.services,
      queryParameters: {'page': page, 'limit': limit},
    );
    return _pageFromResponse(response.data);
  }

  ServicesPage _pageFromResponse(dynamic body) {
    final list = _extractList(body);
    final pagination = body is Map ? body['pagination'] as Map<String, dynamic>? : null;
    final services = list.map(_serviceFromJson).toList();
    return ServicesPage(
      services: services,
      totalServices: (pagination?['totalServices'] as num?)?.toInt() ??
          (pagination?['totalProducts'] as num?)?.toInt() ??
          services.length,
      totalPages: (pagination?['totalPages'] as num?)?.toInt() ?? 1,
      currentPage: (pagination?['currentPage'] as num?)?.toInt() ?? 1,
    );
  }

  List<Map<String, dynamic>> _extractList(dynamic body) {
    if (body is List) {
      return body.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    if (body is Map) {
      final data = body['data'];
      if (data is List) {
        return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
    }
    return [];
  }

  Map<String, dynamic> _unwrapData(dynamic body) {
    if (body is Map && body['data'] is Map) {
      return Map<String, dynamic>.from(body['data'] as Map);
    }
    if (body is Map) return Map<String, dynamic>.from(body);
    throw const FormatException('Invalid service response');
  }

  Service _serviceFromJson(Map<String, dynamic> json) {
    try {
      return Service.fromJson(json);
    } catch (_) {
      final product = Product.fromJson(json);
      return Service(
        id: product.id,
        name: product.title,
        description: product.description,
        price: product.price,
        category: product.category ?? '',
        image: product.firstImageUrl.isNotEmpty ? product.firstImageUrl : null,
      );
    }
  }
}
