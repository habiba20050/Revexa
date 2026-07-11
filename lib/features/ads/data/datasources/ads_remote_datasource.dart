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
  /// Returns a map with keys `url` and `public_id`.
  Future<Map<String, String>> uploadImage(String filePath, {String? folder});
  Future<Map<String, String>> uploadImageBytes(List<int> bytes, {String fileName, String? folder});
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
  Future<Map<String, String>> uploadImage(String filePath, {String? folder}) async {
    try {
      final file = await MultipartFile.fromFile(filePath);
      final form = <String, dynamic>{'images': file};
      if (folder != null) form['folder'] = folder;
      final response = await _dio.post(
        ApiEndpoints.upload,
        data: FormData.fromMap(form),
      );
      final body = response.data;
      if (body is Map) {
        String url = '';
        String publicId = '';
        if (body['secure_url'] != null) url = body['secure_url'].toString();
        if (body['url'] != null) url = body['url'].toString();
        final data = body['data'];
        if (data is List && data.isNotEmpty) {
          final first = data.first;
          if (first is Map) {
            url = (first['url'] ?? first['secure_url'] ?? '').toString();
            publicId = (first['public_id'] ?? first['publicId'] ?? '').toString();
          } else {
            url = first.toString();
          }
        }
        if (data is Map) {
          url = (data['url'] ?? data['secure_url'] ?? '').toString();
          publicId = (data['public_id'] ?? data['publicId'] ?? '').toString();
        }
        if (url.isNotEmpty) return {'url': url, 'public_id': publicId};
      }
      throw Exception('Failed to upload image: invalid response format');
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<Map<String, String>> uploadImageBytes(List<int> bytes, {String fileName = 'upload.jpg', String? folder}) async {
    try {
      final file = MultipartFile.fromBytes(bytes, filename: fileName);
      final form = <String, dynamic>{'images': file};
      if (folder != null) form['folder'] = folder;
      final response = await _dio.post(
        ApiEndpoints.upload,
        data: FormData.fromMap(form),
      );
      final body = response.data;
      if (body is Map) {
        String url = '';
        String publicId = '';
        if (body['secure_url'] != null) url = body['secure_url'].toString();
        if (body['url'] != null) url = body['url'].toString();
        final data = body['data'];
        if (data is List && data.isNotEmpty) {
          final first = data.first;
          if (first is Map) {
            url = (first['url'] ?? first['secure_url'] ?? '').toString();
            publicId = (first['public_id'] ?? first['publicId'] ?? '').toString();
          } else {
            url = first.toString();
          }
        }
        if (data is Map) {
          url = (data['url'] ?? data['secure_url'] ?? '').toString();
          publicId = (data['public_id'] ?? data['publicId'] ?? '').toString();
        }
        if (url.isNotEmpty) return {'url': url, 'public_id': publicId};
      }
      throw Exception('Failed to upload image: invalid response format');
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}
