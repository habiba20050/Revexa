import 'package:dio/dio.dart';
import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/features/ads/data/models/ad_model.dart';

abstract interface class AdsRemoteDataSource {
  Future<List<AdModel>> getAds();
  Future<AdModel> createAd({
    required String title,
    required String imageUrl,
    String? description,
    String? actionUrl,
  });
  Future<AdModel> updateAd(
    String id, {
    String? title,
    String? imageUrl,
    String? description,
    String? actionUrl,
    bool? isActive,
  });
  Future<void> deleteAd(String id);
  Future<String> uploadImage(String filePath);
}

class AdsRemoteDataSourceImpl implements AdsRemoteDataSource {
  Dio get _dio => _dioClient.dio;
  final DioClient _dioClient;

  AdsRemoteDataSourceImpl({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient.instance;

  @override
  Future<List<AdModel>> getAds() async {
    try {
      final response = await _dio.get(ApiEndpoints.ads);
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        return const [];
      }
      final data = body['data'];
      if (data is List) {
        return data.map((e) => AdModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return const [];
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<AdModel> createAd({
    required String title,
    required String imageUrl,
    String? description,
    String? actionUrl,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.ads,
        data: {
          'title': title,
          'image': imageUrl,
          if (description != null) 'description': description,
          if (actionUrl != null) 'url': actionUrl,
        },
      );
      final body = response.data;
      final data = body['data'] ?? body;
      return AdModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<AdModel> updateAd(
    String id, {
    String? title,
    String? imageUrl,
    String? description,
    String? actionUrl,
    bool? isActive,
  }) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.adById(id),
        data: {
          if (title != null) 'title': title,
          if (imageUrl != null) 'image': imageUrl,
          if (description != null) 'description': description,
          if (actionUrl != null) 'url': actionUrl,
          if (isActive != null) 'isActive': isActive,
        },
      );
      final body = response.data;
      final data = body['data'] ?? body;
      return AdModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> deleteAd(String id) async {
    try {
      await _dio.delete(ApiEndpoints.adById(id));
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<String> uploadImage(String filePath) async {
    try {
      final file = await MultipartFile.fromFile(filePath);
      final response = await _dio.post(
        ApiEndpoints.upload,
        data: FormData.fromMap({'images': file}),
      );
      final body = response.data;
      if (body is Map) {
        if (body['secure_url'] != null) return body['secure_url'].toString();
        if (body['url'] != null) return body['url'].toString();
        final data = body['data'];
        if (data is List && data.isNotEmpty) {
          final first = data.first;
          if (first is Map) {
            return (first['url'] ?? first['secure_url'] ?? '').toString();
          }
          return first.toString();
        }
        if (data is Map) {
          return (data['url'] ?? data['secure_url'] ?? '').toString();
        }
      }
      throw Exception('Failed to upload image: invalid response format');
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}
