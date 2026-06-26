import 'package:dio/dio.dart';
import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/features/products/data/models/product_model.dart';

abstract interface class ProductsRemoteDataSource {
  Future<ProductsPage> getAllProducts({int page = 1, int limit = 10});
  Future<Product> getProductById(String id);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  // Getter instead of field — never holds a stale Dio reference.
  Dio get _dio => DioClient.instance.dio;

  @override
  Future<ProductsPage> getAllProducts({int page = 1, int limit = 10}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.products,
        queryParameters: {'page': page, 'limit': limit},
      );

      // Safe extraction — backend may return:
      // { "data": [...] }  or  { "products": [...] }  or  [...]
      final body = response.data;
      final List<dynamic> data = _extractList(body);
      final pagination = body is Map ? (body['pagination'] as Map<String, dynamic>?) : null;

      return ProductsPage(
        products: data
            .whereType<Map<String, dynamic>>()
            .map(Product.fromJson)
            .toList(),
        totalProducts: (pagination?['totalProducts'] as num?)?.toInt() ??
            (pagination?['total'] as num?)?.toInt() ??
            data.length,
        totalPages: (pagination?['totalPages'] as num?)?.toInt() ?? 1,
        currentPage: (pagination?['currentPage'] as num?)?.toInt() ?? page,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.productById(id));
      final data = _unwrapSingle(response.data);
      return Product.fromJson(data);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  // ─── Parsing helpers ──────────────────────────────────────────────────────

  static List<dynamic> _extractList(dynamic body) {
    if (body is List) return body;
    if (body is Map) {
      final data = body['data'];
      if (data is List) return data;
      final products = body['products'];
      if (products is List) return products;
    }
    return [];
  }

  static Map<String, dynamic> _unwrapSingle(dynamic body) {
    if (body is Map && body['data'] is Map) {
      return Map<String, dynamic>.from(body['data'] as Map);
    }
    if (body is Map) return Map<String, dynamic>.from(body);
    throw const FormatException('Unexpected product response format');
  }
}
