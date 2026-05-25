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
  final Dio _dio;
  ProductsRemoteDataSourceImpl() : _dio = DioClient.instance.dio;

  @override
  Future<ProductsPage> getAllProducts({int page = 1, int limit = 10}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.products,
        queryParameters: {'page': page, 'limit': limit},
      );
      final data = response.data['data'] as List<dynamic>;
      final pagination = response.data['pagination'] as Map<String, dynamic>? ?? {};
      return ProductsPage(
        products: data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList(),
        totalProducts: (pagination['totalProducts'] as num?)?.toInt() ?? 0,
        totalPages: (pagination['totalPages'] as num?)?.toInt() ?? 1,
        currentPage: (pagination['currentPage'] as num?)?.toInt() ?? page,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.productById(id));
      return Product.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}
