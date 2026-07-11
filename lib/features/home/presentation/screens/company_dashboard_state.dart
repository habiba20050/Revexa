import 'package:equatable/equatable.dart';
import 'package:revexa/features/products/data/models/product_model.dart';

abstract class CompanyDashboardState extends Equatable {
  const CompanyDashboardState();

  @override
  List<Object> get props => [];
}

class CompanyDashboardInitial extends CompanyDashboardState {}

class CompanyDashboardLoading extends CompanyDashboardLoaded {
  const CompanyDashboardLoading(super.products);
}

class CompanyDashboardLoaded extends CompanyDashboardState {
  final List<Product> products;

  const CompanyDashboardLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class CompanyDashboardError extends CompanyDashboardState {
  final String message;

  const CompanyDashboardError(this.message);
}