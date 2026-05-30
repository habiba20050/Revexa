import 'package:dio/dio.dart';
import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/api_response.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/core/storage/secure_storage.dart';
import 'package:revexa/features/auth/data/models/auth_user_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<AuthUser> getProfile();
  Future<AuthUser> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
    String? address,
    String? imageUrl,
  });
  Future<String> uploadImage(String filePath, {String? fileName});
  Future<String> uploadImageBytes(List<int> bytes, {String fileName = 'avatar.jpg'});
  Future<void> deleteAccount();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;
  ProfileRemoteDataSourceImpl() : _dio = DioClient.instance.dio;

  Future<String> _token() async {
    final token = await SecureStorage.instance.getToken();
    return token ?? '';
  }

  @override
  Future<AuthUser> getProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.profile);
      final data = ApiResponse.unwrap(response.data);
      final userMap = data['user'] is Map
          ? Map<String, dynamic>.from(data['user'] as Map)
          : data;
      return AuthUser.fromUserMap(userMap, token: await _token());
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<AuthUser> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
    String? address,
    String? imageUrl,
  }) async {
    try {
      final fullName = '$firstName $lastName'.trim();
      final response = await _dio.put(
        ApiEndpoints.profileUpdate,
        data: {
          'name': fullName,
          'firstName': firstName,
          'lastName': lastName,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          if (address != null && address.isNotEmpty) 'address': address,
          if (imageUrl != null && imageUrl.isNotEmpty) 'image': imageUrl,
        },
      );
      final data = ApiResponse.unwrap(response.data);
      final userMap = data['user'] is Map
          ? Map<String, dynamic>.from(data['user'] as Map)
          : data;
      return AuthUser.fromUserMap(userMap, token: await _token());
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<String> uploadImage(String filePath, {String? fileName}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.upload,
        data: FormData.fromMap({
          'images': [
            await MultipartFile.fromFile(
              filePath,
              filename: fileName ?? 'avatar.jpg',
            ),
          ],
        }),
      );
      return _parseUploadUrl(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<String> uploadImageBytes(List<int> bytes, {String fileName = 'avatar.jpg'}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.upload,
        data: FormData.fromMap({
          'images': [
            MultipartFile.fromBytes(bytes, filename: fileName),
          ],
        }),
      );
      return _parseUploadUrl(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  String _parseUploadUrl(dynamic body) {
    if (body is! Map) {
      throw Exception('Upload response did not include an image URL');
    }
    final map = Map<String, dynamic>.from(body);
    final data = map['data'];
    final candidates = <dynamic>[
      if (data is Map) ...[
        data['url'],
        data['image'],
        data['imageUrl'],
        _firstImageUrl(data['images']),
      ],
      map['url'],
      map['image'],
      map['imageUrl'],
      _firstImageUrl(map['images']),
      if (data is List) _firstImageUrl(data),
    ];
    for (final c in candidates) {
      if (c != null && c.toString().isNotEmpty) return c.toString();
    }
    throw Exception('Upload response did not include an image URL');
  }

  String? _firstImageUrl(dynamic images) {
    if (images is! List || images.isEmpty) return null;
    final first = images.first;
    if (first is Map) {
      return first['url']?.toString() ?? first['secure_url']?.toString();
    }
    return first?.toString();
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _dio.delete(ApiEndpoints.deleteAccount);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}
