import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/api_response.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/core/storage/secure_storage.dart';
import 'package:revexa/core/utils/image_url_utils.dart';
import 'package:revexa/features/auth/data/models/auth_user_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<AuthUser> getProfile();
  Future<AuthUser> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
    String? address,
  });
  Future<AuthUser> uploadAvatar(String filePath, {String? fileName});
  Future<AuthUser> uploadAvatarBytes(List<int> bytes, {String fileName = 'avatar.jpg'});
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
      return _parseUserResponse(response.data);
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
  }) async {
    try {
      final body = <String, dynamic>{
        'firstName': firstName,
        'lastName': lastName,
      };
      if (phone != null && phone.isNotEmpty) body['phone'] = phone;
      if (address != null && address.isNotEmpty) body['address'] = address;

      final response = await _dio.put(
        ApiEndpoints.profileUpdate,
        data: body,
      );
      return _parseUserResponse(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<AuthUser> uploadAvatar(String filePath, {String? fileName}) async {
    final name = fileName ?? 'avatar.jpg';
    final file = await MultipartFile.fromFile(
      filePath,
      filename: name,
      contentType: _mediaTypeFor(name),
    );
    return _patchAvatar(file);
  }

  @override
  Future<AuthUser> uploadAvatarBytes(List<int> bytes, {String fileName = 'avatar.jpg'}) async {
    final file = MultipartFile.fromBytes(
      bytes,
      filename: fileName,
      contentType: _mediaTypeFor(fileName),
    );
    return _patchAvatar(file);
  }

  /// PATCH /users/avatar — multipart field `image`.
  /// NOTE: This endpoint is not yet implemented on the backend (returns 404).
  /// On 404 we fall back silently and return the current profile to avoid
  /// a misleading error when the user saves profile changes with a new photo.
  Future<AuthUser> _patchAvatar(MultipartFile file) async {
    try {
      final response = await _dio.patch(
        ApiEndpoints.avatarUpload,
        data: FormData.fromMap({'image': file}),
      );
      return _parseUserResponse(response.data);
    } on DioException catch (e) {
      // 404 means the endpoint doesn't exist yet — return current profile.
      if (e.response?.statusCode == 404) {
        return getProfile();
      }
      throw ErrorHandler.handleDioError(e);
    }
  }

  MediaType _mediaTypeFor(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.png')) return MediaType('image', 'png');
    if (lower.endsWith('.webp')) return MediaType('image', 'webp');
    if (lower.endsWith('.gif')) return MediaType('image', 'gif');
    return MediaType('image', 'jpeg');
  }

  Future<AuthUser> _parseUserResponse(dynamic body) async {
    final data = ApiResponse.unwrap(body);
    var userMap = data['user'] is Map
        ? Map<String, dynamic>.from(data['user'] as Map)
        : data;
    userMap = _normalizeUserMap(userMap);
    return AuthUser.fromUserMap(userMap, token: await _token());
  }

  Map<String, dynamic> _normalizeUserMap(Map<String, dynamic> map) {
    final url = ImageUrlUtils.resolve(
      map['image'] ?? map['imageUrl'] ?? map['avatar'],
    );
    if (url != null && url.isNotEmpty) {
      return {
        ...map,
        'imageUrl': url,
        'image': url,
      };
    }
    return map;
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
