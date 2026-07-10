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

/// The backend has no /services endpoint (confirmed 404).
/// The service catalogue is served via /products.
class ServicesRemoteDataSourceImpl implements ServicesRemoteDataSource {
  // Use a getter so we always reference the current Dio instance,
  // never a stale one captured at construction time.
  Dio get _dio => _dioClient.dio;
  final DioClient _dioClient;
  ServicesRemoteDataSourceImpl({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient.instance;

  @override
  Future<ServicesPage> getAllServices({int page = 1, int limit = 10}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.products,
        queryParameters: {'page': page, 'limit': limit},
      );
      return _pageFromResponse(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<Service> getServiceById(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.productById(id));
      final data = _unwrapData(response.data);
      return _serviceFromJson(data);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<List<Service>> getServicesByCategory(String category) async {
    // Fetch all (up to 100) and filter client-side since the backend
    // does not expose a category query parameter on /products.
    final page = await getAllServices(limit: 100);
    return page.services
        .where((s) => s.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // ─── Parsing helpers ──────────────────────────────────────────────────────

  ServicesPage _pageFromResponse(dynamic body) {
    final list = _extractList(body);
    final pagination =
        body is Map ? body['pagination'] as Map<String, dynamic>? : null;
    final services = list.map(_serviceFromJson).toList();
    return ServicesPage(
      services: services,
      totalServices: (pagination?['totalProducts'] as num?)?.toInt() ??
          (pagination?['totalServices'] as num?)?.toInt() ??
          (pagination?['total'] as num?)?.toInt() ??
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
      // Some endpoints return { products: [...] }
      final products = body['products'];
      if (products is List) {
        return products
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
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
    // Try native Service shape first, then fall back to Product shape.
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
