import 'package:equatable/equatable.dart';
import 'package:revexa/features/products/data/models/product_model.dart';

/// يمثل الحالات المختلفة لواجهة مستخدم لوحة تحكم الشركة.
abstract class CompanyDashboardState extends Equatable {
  const CompanyDashboardState();

  @override
  List<Object> get props => [];
}

/// الحالة الأولية قبل تحميل أي بيانات.
class CompanyDashboardInitial extends CompanyDashboardState {}

/// حالة جاري تحميل الخدمات.
class CompanyDashboardLoading extends CompanyDashboardState {}

/// حالة نجاح تحميل الخدمات.
class CompanyDashboardLoaded extends CompanyDashboardState {
  final List<Product> services;
  const CompanyDashboardLoaded(this.services);
  @override
  List<Object> get props => [services];
}

/// حالة حدوث خطأ أثناء تحميل الخدمات.
class CompanyDashboardError extends CompanyDashboardState {
  final String message;
  const CompanyDashboardError(this.message);
  @override
  List<Object> get props => [message];
}