
import 'package:dio/dio.dart';
import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/features/auth/data/models/auth_user_model.dart';
import 'package:revexa/features/products/data/models/product_model.dart';

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

  /// Fetches all products/services offered by a specific user (company).
  Future<List<Product>> getProductsByUserId(String userId);
}

/// Implementation of the [UserManagementRemoteDataSource].
class UserManagementRemoteDataSourceImpl implements UserManagementRemoteDataSource {
  // Use a getter so we always reference the current Dio instance from the client,
  // never a stale one captured at construction time.
  Dio get _dio => _dioClient.dio;

  final DioClient _dioClient;
  UserManagementRemoteDataSourceImpl({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient.instance;

  @override
  Future<List<AuthUser>> getAllUsers({required int page, required int limit}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.users,
        queryParameters: {'page': page, 'limit': limit},
      );
      final userList = _unwrapList(response.data);
      final users = userList.map((userJson) => AuthUser.fromJson(userJson)).toList();
      return users;
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<AuthUser> getUserById(String userId) async {
    try {
      final response = await _dio.get(ApiEndpoints.userById(userId));
      final userMap = _unwrapData(response.data);
      return AuthUser.fromJson(userMap);
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
      final response = await _dio.put(
        ApiEndpoints.userById(userId),
        data: data,
      );
      final userMap = _unwrapData(response.data);
      return AuthUser.fromJson(userMap);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<List<Product>> getProductsByUserId(String userId) async {
    try {
      // NOTE: This assumes the backend supports `GET /products?userId={id}`
      final response = await _dio.get(ApiEndpoints.productsByUserId(userId));
      final productList = _unwrapList(response.data);
      final products = productList.map((json) => Product.fromJson(json)).toList();
      return products;
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  // ─── Parsing Helpers ──────────────────────────────────────────────────────

  Map<String, dynamic> _unwrapData(dynamic body) {
    if (body is Map && body['data'] is Map) {
      return Map<String, dynamic>.from(body['data'] as Map);
    }
    if (body is Map) return Map<String, dynamic>.from(body);
    throw const FormatException('Invalid API response format: Expected a data object.');
  }

  List<Map<String, dynamic>> _unwrapList(dynamic body) {
    if (body is Map && body['data'] is List) {
      return (body['data'] as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
    throw const FormatException('Invalid API response format: Expected a data list.');
  }
}