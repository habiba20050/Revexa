import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/core/utils/result.dart';

// Model
class Category extends Equatable {
  final String id;
  final String name;
  final String? description;

  const Category({required this.id, required this.name, this.description});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
    );
  }

  @override
  List<Object?> get props => [id, name, description];
}

// DataSource
class CategoriesRemoteDataSource {
  final Dio _dio;
  CategoriesRemoteDataSource() : _dio = DioClient.instance.dio;

  Future<List<Category>> getAllCategories() async {
    try {
      final response = await _dio.get(ApiEndpoints.categories);
      final body = response.data;
      List<dynamic> data;
      if (body is Map && body['data'] is List) {
        data = body['data'] as List<dynamic>;
      } else if (body is List) {
        data = body;
      } else {
        data = [];
      }
      return data.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}

// Repository
class CategoriesRepository {
  final CategoriesRemoteDataSource _remote;
  CategoriesRepository(this._remote);

  Future<Result<List<Category>>> getAllCategories() async {
    try {
      final result = await _remote.getAllCategories();
      return Success(result);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }
}

// States
abstract class CategoriesState extends Equatable {
  const CategoriesState();
  @override
  List<Object?> get props => [];
}

class CategoriesInitial extends CategoriesState {
  const CategoriesInitial();
}

class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

class CategoriesLoaded extends CategoriesState {
  final List<Category> categories;
  const CategoriesLoaded(this.categories);
  @override
  List<Object?> get props => [categories];
}

class CategoriesError extends CategoriesState {
  final String message;
  const CategoriesError(this.message);
  @override
  List<Object?> get props => [message];
}

// Cubit
class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesRepository _repository;

  CategoriesCubit(this._repository) : super(const CategoriesInitial());

  Future<void> loadCategories() async {
    if (state is CategoriesLoaded) return; // avoid re-fetching on success
    // Always retry if in error state or initial
    emit(const CategoriesLoading());
    final result = await _repository.getAllCategories();
    if (result is Success) {
      emit(CategoriesLoaded(result.data!));
    } else {
      emit(CategoriesError(result.failure!.message));
    }
  }
}
