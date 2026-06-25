import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/api_response.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/features/auth/data/models/auth_user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthUser> login({required String email, required String password});
  Future<AuthUser> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required int age,
    required String gender,
    required String address,
  });
  Future<void> logout();
  Future<void> forgotPassword(String email);
  Future<AuthUser> signInWithGoogle({required String accessToken, String? idToken});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSourceImpl() : _dio = DioClient.instance.dio;

  @override
  Future<AuthUser> login({required String email, required String password}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      final data = ApiResponse.unwrap(response.data);
      return AuthUser.fromUserMap(data['user'], token: data['token']);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<AuthUser> signInWithGoogle({required String accessToken, String? idToken}) async {
    // On web: FedCM returns JWT as idToken
    // On native: both might be present
    if (idToken == null || idToken.isEmpty) {
      if (accessToken.isEmpty) {
        throw ArgumentError('Either accessToken or idToken is required for Google Sign-In');
      }
    }

    try {
      // Backend expects both 'accessToken' and 'idToken'
      // On web: both will be the FedCM JWT
      final requestData = {
        'accessToken': accessToken,
        if (idToken != null && idToken.isNotEmpty) 'idToken': idToken,
      };
      
      // Debug: log first 50 chars of tokens
      debugPrint('GoogleAuth Request - accessToken: ${accessToken.substring(0, 50)}...');
      debugPrint('GoogleAuth Request - idToken: ${idToken?.substring(0, 50) ?? "null"}...');
      
      final response = await _dio.post(
        ApiEndpoints.googleLogin,
        data: requestData,
      );
      final data = ApiResponse.unwrap(response.data);
      return AuthUser.fromUserMap(data['user'], token: data['token']);
    } on DioException catch (e) {
      debugPrint('GoogleAuth DioException: ${e.message}');
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required int age,
    required String gender,
    required String address,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone,
          'age': age,
          'gender': gender,
          'address': address,
        },
      );
      final data = ApiResponse.unwrap(response.data);
      return AuthUser.fromUserMap(data['user'], token: data['token']);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post(
        ApiEndpoints.logout,
        options: Options(
          validateStatus: (status) =>
              status == null ||
              status == 200 ||
              status == 204 ||
              status == 401,
        ),
      );
    } on DioException catch (e) {
      // Logout locally regardless
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post(ApiEndpoints.forgotPassword, data: {'email': email});
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}
