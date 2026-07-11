import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revexa/core/network/user_management_repository.dart';
import 'package:revexa/features/products/data/repositories/products_repository_impl.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/products/data/models/product_model.dart';
import 'package:revexa/features/home/presentation/screens/company_dashboard_state.dart';

/// Cubit لإدارة حالة لوحة تحكم الشركة.
///
/// مسؤول عن جلب خدمات الشركة من خلال `UserManagementRepository`.
class CompanyDashboardCubit extends Cubit<CompanyDashboardState> {
  // We keep UserManagementRepository to fetch products by user ID.
  final UserManagementRepository _userManagementRepository;
  // We add ProductsRepository to manage (CUD) products.
  final ProductsRepository _productsRepository;

  CompanyDashboardCubit(this._userManagementRepository, this._productsRepository)
      : super( CompanyDashboardInitial());

  /// يقوم بتحميل قائمة الخدمات (المنتجات) الخاصة بشركة معينة.
  Future<void> loadCompanyServices(String userId) async {
    // Show loading only if there are no products yet.
    if (state is! CompanyDashboardLoaded) {
      emit(CompanyDashboardLoading(const []));
    }
    try {
      final result = await _userManagementRepository.getProductsByUserId(userId);
      if (result is Success<List<Product>>) {
        emit(CompanyDashboardLoaded(result.data!));
      } else {
        emit(CompanyDashboardError(result.failure!.message));
      }
    } catch (e) {
      emit(CompanyDashboardError('An unexpected error occurred: $e'));
    }
  }

  /// Updates an existing product and refreshes the list.
  Future<void> updateProduct(String productId, Map<String, dynamic> data) async {
    try {
      final result = await _productsRepository.updateProduct(productId, data);
      if (result is Success) {
        final currentState = state;
        if (currentState is CompanyDashboardLoaded) {
          final updatedProduct = (result as Success<Product>).value;
          // Replace the old product with the updated one
          final updatedList = currentState.products
              .map((p) => p.id == productId ? updatedProduct : p)
              .toList();
          emit(CompanyDashboardLoaded(updatedList));
        }
      }
      // You might want to emit an error state if the update fails
    } catch (e) {
      // Handle or log the error
    }
  }

  /// يحذف خدمة.
  Future<bool> deleteProduct(String productId) async {
    try {
      final result = await _productsRepository.deleteProduct(productId);
      if (result is Success) {
        final currentState = state;
        if (currentState is CompanyDashboardLoaded) {
          final updatedList = currentState.products.where((p) => p.id != productId).toList();
          emit(CompanyDashboardLoaded(updatedList));
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}