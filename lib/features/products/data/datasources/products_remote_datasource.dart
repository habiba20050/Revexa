import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/features/products/data/models/product_model.dart';

abstract interface class ProductsRemoteDataSource {
  Future<ProductsPage> getAllProducts({int page = 1, int limit = 10});
  Future<Product> getProductById(String id);
  Future<Product> createProduct({
    required String title,
    required String description,
    required double price,
    String? category,
    String? location,
    List<XFile>? images,
  });

  Future<Product> updateProduct(String id, Map<String, dynamic> data);
  Future<void> deleteProduct(String id);
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

  @override
  Future<Product> createProduct({
    required String title,
    required String description,
    required double price,
    String? category,
    String? location,
    List<XFile>? images,
  }) async {
    try {
      // Create a FormData object to send text fields and files together.
      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        'price': price.toString(),
        if (category != null && category.isNotEmpty) 'category': category,
        if (location != null && location.isNotEmpty) 'location': location,
      });

      // Append image files to the FormData.
      // The backend expects them under the 'images' key.
      if (images != null && images.isNotEmpty) {
        for (final file in images) {
          if (kIsWeb) {
            // For web, use fromBytes
            final bytes = await file.readAsBytes();
            formData.files.add(MapEntry(
              'images',
              MultipartFile.fromBytes(bytes, filename: file.name),
            ));
          } else {
            // For mobile, use fromFile
            formData.files.add(MapEntry('images', await MultipartFile.fromFile(file.path, filename: file.name)));
          }
        }
      }

      final response = await _dio.post(
        ApiEndpoints.products,
        data: formData,
      );
      final data = _unwrapSingle(response.data);
      return Product.fromJson(data);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<Product> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(ApiEndpoints.productById(id), data: data);
      final body = _unwrapSingle(response.data);
      return Product.fromJson(body);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await _dio.delete(ApiEndpoints.productById(id));
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
