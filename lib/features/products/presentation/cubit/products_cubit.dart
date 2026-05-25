import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/products/data/models/product_model.dart';
import 'package:revexa/features/products/data/repositories/products_repository_impl.dart';

// ─── States ──────────────────────────────────────────────────────────────────

abstract class ProductsState extends Equatable {
  const ProductsState();
  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsLoaded extends ProductsState {
  final ProductsPage page;
  const ProductsLoaded(this.page);
  @override
  List<Object?> get props => [page];
}

class ProductDetailLoading extends ProductsState {
  const ProductDetailLoading();
}

class ProductDetailLoaded extends ProductsState {
  final Product product;
  const ProductDetailLoaded(this.product);
  @override
  List<Object?> get props => [product];
}

class ProductsError extends ProductsState {
  final String message;
  const ProductsError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── Cubit ───────────────────────────────────────────────────────────────────

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepository _repository;

  ProductsCubit(this._repository) : super(const ProductsInitial());

  Future<void> loadProducts({int page = 1, int limit = 10}) async {
    if (isClosed) return;
    emit(const ProductsLoading());
    try {
      final result = await _repository.getAllProducts(page: page, limit: limit);
      if (isClosed) return;
      if (result is Success) {
        emit(ProductsLoaded(result.data!));
      } else {
        emit(ProductsError(result.failure!.message));
      }
    } catch (e) {
      if (!isClosed) emit(ProductsError('Unexpected error: $e'));
    }
  }

  Future<void> loadProductById(String id) async {
    if (isClosed) return;
    emit(const ProductDetailLoading());
    try {
      final result = await _repository.getProductById(id);
      if (isClosed) return;
      if (result is Success) {
        emit(ProductDetailLoaded(result.data!));
      } else {
        emit(ProductsError(result.failure!.message));
      }
    } catch (e) {
      if (!isClosed) emit(ProductsError('Unexpected error: $e'));
    }
  }
}
