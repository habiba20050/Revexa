import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/features/auth/data/auth_response_parser.dart';
import 'package:revexa/features/auth/data/models/auth_user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthUser> login({required String email, required String password});
  Future<AuthUser> register({
    required String email,
    required String password,
    String? role,
    String? name,
    String? firstName,
    String? lastName,
    String? phone,
    int? age,
    String? gender,
    String? address,
  });
  Future<void> logout();
  Future<void> forgotPassword(String email);
  Future<String> verifyResetCode({required String email, required String code});
  Future<AuthUser> signInWithGoogle({required String accessToken, String? idToken});
  Future<AuthUser> resetPassword({required String token, required String password});
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
      return AuthResponseParser.parse(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<AuthUser> signInWithGoogle({required String accessToken, String? idToken}) async {
    if (idToken == null || idToken.isEmpty) {
      if (accessToken.isEmpty) {
        throw ArgumentError('Either accessToken or idToken is required for Google Sign-In');
      }
    }

    try {
      final requestData = {
        'accessToken': accessToken,
        if (idToken != null && idToken.isNotEmpty) 'idToken': idToken,
      };

      debugPrint('GoogleAuth Request - accessToken: ${accessToken.substring(0, 50)}...');
      debugPrint('GoogleAuth Request - idToken: ${idToken?.substring(0, 50) ?? "null"}...');

      final response = await _dio.post(
        ApiEndpoints.googleLogin,
        data: requestData,
      );
      return AuthResponseParser.parse(response.data);
    } on DioException catch (e) {
      debugPrint('GoogleAuth DioException: ${e.message}');
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
    String? role,
    String? name,
    String? firstName,
    String? lastName,
    String? phone,
    int? age,
    String? gender,
    String? address,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          if (role != null) 'role': role,
          if (name != null) 'name': name,
          if (firstName != null) 'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
          if (phone != null) 'phone': phone,
          if (age != null) 'age': age,
          if (gender != null) 'gender': gender,
          if (address != null) 'address': address,
        },
      );
      return AuthResponseParser.parse(response.data);
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

  @override
  Future<String> verifyResetCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.verifyResetCode,
        data: {'email': email, 'code': code},
      );
      final body = response.data;
      // Expected shape: { data: { resetToken: '...' } } or { resetToken: '...' }
      String? token;
      if (body is Map) {
        final map = Map<String, dynamic>.from(body);
        if (map['data'] is Map) {
          token = (map['data'] as Map)['resetToken']?.toString();
        }
        token ??= map['resetToken']?.toString();
      }
      if (token == null || token.isEmpty) {
        throw const FormatException('Server did not return a reset token');
      }
      return token;
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<AuthUser> resetPassword({
    required String token,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.resetPassword,
        data: {'token': token, 'password': password},
      );
      return AuthResponseParser.parse(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}
