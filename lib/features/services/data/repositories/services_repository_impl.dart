import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/services/data/datasources/services_remote_datasource.dart';
import 'package:revexa/features/services/data/models/service_model.dart';

abstract interface class ServicesRepository {
  Future<Result<ServicesPage>> getAllServices({int page = 1, int limit = 10});
  Future<Result<Service>> getServiceById(String id);
  Future<Result<List<Service>>> getServicesByCategory(String category);
}

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesRemoteDataSource _remote;
  ServicesRepositoryImpl(this._remote);

  @override
  Future<Result<ServicesPage>> getAllServices({int page = 1, int limit = 10}) async {
    try {
      final result = await _remote.getAllServices(page: page, limit: limit);
      return Success(result);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<Service>> getServiceById(String id) async {
    try {
      final result = await _remote.getServiceById(id);
      return Success(result);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<List<Service>>> getServicesByCategory(String category) async {
    try {
      final result = await _remote.getServicesByCategory(category);
      return Success(result);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }
}
