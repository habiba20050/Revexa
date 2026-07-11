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
  /// Sends only the [idToken] (JWT from Google) to the backend.
  Future<AuthUser> signInWithGoogle({required String idToken});
  /// Resets the user's password. Returns void — the backend returns a message
  /// only, not a user or token.
  Future<void> resetPassword({required String token, required String password});
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
  Future<AuthUser> signInWithGoogle({required String idToken}) async {
    if (idToken.isEmpty) {
      throw ArgumentError('idToken must not be empty for Google Sign-In');
    }
    try {
      debugPrint('GoogleAuth Request — idToken[:50]: ${idToken.substring(0, idToken.length.clamp(0, 50))}...');
      final response = await _dio.post(
        ApiEndpoints.googleLogin,
        data: {'idToken': idToken},
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
      String? token;
      if (body is String) {
        token = body;
      } else if (body is Map) {
        final map = Map<String, dynamic>.from(body);
        // 1. Direct fields
        if (map['resetToken'] != null) {
          token = map['resetToken'].toString();
        } else if (map['token'] != null) {
          token = map['token'].toString();
        }
        // 2. Inside 'data' object or string
        else if (map['data'] != null) {
          final dataVal = map['data'];
          if (dataVal is Map) {
            final dataMap = Map<String, dynamic>.from(dataVal);
            token = (dataMap['resetToken'] ?? dataMap['token'])?.toString();
          } else {
            token = dataVal.toString();
          }
        }
      }
      if (token == null || token.trim().isEmpty) {
        throw const FormatException('Server did not return a valid reset token');
      }
      return token.trim();
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    try {
      // The backend accepts the token as 'resetToken'.
      // It returns { message: "..." } only — no user or JWT.
      await _dio.post(
        ApiEndpoints.resetPassword,
        data: {
          'resetToken': token,
          'password': password,
        },
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}

