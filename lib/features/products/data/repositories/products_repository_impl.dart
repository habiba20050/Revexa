import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/products/data/datasources/products_remote_datasource.dart';
import 'package:revexa/features/products/data/models/product_model.dart';

abstract interface class ProductsRepository {
  Future<Result<ProductsPage>> getAllProducts({int page = 1, int limit = 10});
  Future<Result<Product>> getProductById(String id);
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
}
