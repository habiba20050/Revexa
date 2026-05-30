import 'package:equatable/equatable.dart';
import 'package:revexa/features/services/data/models/service_model.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object?> get props => [];
}

class ServicesInitial extends ServicesState {
  const ServicesInitial();
}

class ServicesLoading extends ServicesState {
  const ServicesLoading();
}

class ServicesLoaded extends ServicesState {
  final ServicesPage servicesPage;

  const ServicesLoaded(this.servicesPage);

  @override
  List<Object?> get props => [servicesPage];
}

class ServiceDetailLoading extends ServicesState {
  const ServiceDetailLoading();
}

class ServiceDetailLoaded extends ServicesState {
  final Service service;

  const ServiceDetailLoaded(this.service);

  @override
  List<Object?> get props => [service];
}

class ServicesByCategory extends ServicesState {
  final List<Service> services;
  final String category;

  const ServicesByCategory(this.services, this.category);

  @override
  List<Object?> get props => [services, category];
}

class ServicesError extends ServicesState {
  final String message;

  const ServicesError(this.message);

  @override
  List<Object?> get props => [message];
}
