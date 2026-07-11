import 'package:revexa/core/error/error_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/products/data/datasources/products_remote_datasource.dart';
import 'package:revexa/features/products/data/models/product_model.dart';

abstract interface class ProductsRepository {
  Future<Result<ProductsPage>> getAllProducts({int page = 1, int limit = 10});
  Future<Result<Product>> getProductById(String id);
  Future<Result<Product>> createProduct({
    required String title,
    required String description,
    required double price,
    String? category,
    String? location,
    List<XFile>? images,
  });
  Future<Result<Product>> updateProduct(String id, Map<String, dynamic> data);
  Future<Result<void>> deleteProduct(String id);
}

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource _remote;
  ProductsRepositoryImpl(this._remote);

  @override
  Future<Result<ProductsPage>> getAllProducts({int page = 1, int limit = 10}) async {
    try {
      final result = await _remote.getAllProducts(page: page, limit: limit);
      return Success(result);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<Product>> getProductById(String id) async {
    try {
      final result = await _remote.getProductById(id);
      return Success(result);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<Product>> createProduct({
    required String title,
    required String description,
    required double price,
    String? category,
    String? location,
    List<XFile>? images,
  }) async {
    try {
      final result = await _remote.createProduct(
        title: title,
        description: description,
        price: price,
        category: category,
        location: location,
        images: images,
      );
      return Success(result);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<Product>> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      final result = await _remote.updateProduct(id, data);
      return Success(result);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<void>> deleteProduct(String id) async {
    try {
      await _remote.deleteProduct(id);
      return const Success(null);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }
}
