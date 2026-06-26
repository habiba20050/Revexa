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
      switch (result) {
        case Success<dynamic>():
          emit(ServicesLoaded((result as Success).value));
        case ResultFailure<dynamic>():
          emit(ServicesError((result as ResultFailure).failure.message));
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
      switch (result) {
        case Success<dynamic>():
          emit(ServiceDetailLoaded((result as Success).value));
        case ResultFailure<dynamic>():
          emit(ServicesError((result as ResultFailure).failure.message));
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
      switch (result) {
        case Success<dynamic>():
          emit(ServicesByCategory((result as Success).value, category));
        case ResultFailure<dynamic>():
          emit(ServicesError((result as ResultFailure).failure.message));
      }
    } catch (e) {
      if (!isClosed) emit(ServicesError('Unexpected error: $e'));
    }
  }
}
