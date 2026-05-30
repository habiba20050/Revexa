import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/services/data/repositories/services_repository_impl.dart';
import 'package:revexa/features/services/presentation/cubit/services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final ServicesRepository _repository;

  ServicesCubit(this._repository) : super(const ServicesInitial());

  Future<void> loadServices({int page = 1, int limit = 10}) async {
    if (isClosed) return;
    emit(const ServicesLoading());
    try {
      final result = await _repository.getAllServices(page: page, limit: limit);
      if (isClosed) return;
      if (result is Success) {
        emit(ServicesLoaded(result.data!));
      } else {
        emit(ServicesError(result.failure!.message));
      }
    } catch (e) {
      if (!isClosed) emit(ServicesError('Unexpected error: $e'));
    }
  }

  Future<void> loadServiceById(String id) async {
    if (isClosed) return;
    emit(const ServiceDetailLoading());
    try {
      final result = await _repository.getServiceById(id);
      if (isClosed) return;
      if (result is Success) {
        emit(ServiceDetailLoaded(result.data!));
      } else {
        emit(ServicesError(result.failure!.message));
      }
    } catch (e) {
      if (!isClosed) emit(ServicesError('Unexpected error: $e'));
    }
  }

  Future<void> loadServicesByCategory(String category) async {
    if (isClosed) return;
    emit(const ServicesLoading());
    try {
      final result = await _repository.getServicesByCategory(category);
      if (isClosed) return;
      if (result is Success) {
        emit(ServicesByCategory(result.data!, category));
      } else {
        emit(ServicesError(result.failure!.message));
      }
    } catch (e) {
      if (!isClosed) emit(ServicesError('Unexpected error: $e'));
    }
  }
}
