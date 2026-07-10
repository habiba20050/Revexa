
import 'package:dio/dio.dart';
import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/features/auth/data/models/auth_user_model.dart';

/// Abstract interface for the user management remote data source.
abstract interface class UserManagementRemoteDataSource {
  /// Fetches a paginated list of all users from the API.
  Future<List<AuthUser>> getAllUsers({required int page, required int limit});

  /// Fetches a single user by their ID from the API.
  Future<AuthUser> getUserById(String userId);

  /// Updates a user's profile by their ID via the API.
  Future<AuthUser> updateUser(String userId, Map<String, dynamic> data);

  /// Deletes a user by their ID via the API.
  Future<void> deleteUser(String userId);
}

/// Implementation of the [UserManagementRemoteDataSource].
class UserManagementRemoteDataSourceImpl implements UserManagementRemoteDataSource {
  final Dio _dio;

  UserManagementRemoteDataSourceImpl() : _dio = DioClient.instance.dio;

  @override
  Future<List<AuthUser>> getAllUsers({required int page, required int limit}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.users,
        queryParameters: {'page': page, 'limit': limit},
      );
      final data = response.data;
      final users = (data['data'] as List).map((userJson) => AuthUser.fromJson(userJson)).toList();
      return users;
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<AuthUser> getUserById(String userId) async {
    try {
      final response = await _dio.get(ApiEndpoints.userById(userId));
      return AuthUser.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _dio.delete(
        ApiEndpoints.userById(userId),
        options: Options(
          validateStatus: (status) => status != null && (status == 200 || status == 204),
        ),
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<AuthUser> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch(
        ApiEndpoints.userById(userId),
        data: data,
      );
      return AuthUser.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}