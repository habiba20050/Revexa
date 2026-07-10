import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revexa/core/network/user_management_repository.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/home/presentation/screens/company_dashboard_state.dart';

/// Cubit لإدارة حالة لوحة تحكم الشركة.
///
/// مسؤول عن جلب خدمات الشركة من خلال `UserManagementRepository`.
class CompanyDashboardCubit extends Cubit<CompanyDashboardState> {
  final UserManagementRepository _userManagementRepository;

  CompanyDashboardCubit(this._userManagementRepository) : super(CompanyDashboardInitial());

  /// يقوم بتحميل قائمة الخدمات (المنتجات) الخاصة بشركة معينة.
  Future<void> loadCompanyServices(String userId) async {
    emit(CompanyDashboardLoading());
    try {
      final result = await _userManagementRepository.getProductsByUserId(userId);
      if (result is Success) {
        emit(CompanyDashboardLoaded(result.data!));
      } else {
        emit(CompanyDashboardError(result.failure!.message));
      }
    } catch (e) {
      emit(CompanyDashboardError('An unexpected error occurred: $e'));
    }
  }
}