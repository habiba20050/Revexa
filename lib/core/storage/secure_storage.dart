import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._();
  static final SecureStorage instance = SecureStorage._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _keyToken = 'auth_token';
  static const _keyUserId = 'user_id';
  static const _keyUserEmail = 'user_email';
  static const _keyUserRole = 'user_role';
  static const _keyFirstName = 'user_first_name';
  static const _keyLastName = 'user_last_name';
  static const _keyPhone = 'user_phone';
  static const _keyAddress = 'user_address';
  static const _keyImageUrl = 'user_image_url';

  Future<void> saveToken(String token) =>
      _storage.write(key: _keyToken, value: token);

  Future<String?> getToken() => _storage.read(key: _keyToken);

  Future<void> saveUser({
    required String id,
    required String email,
    required String role,
    required String firstName,
    required String lastName,
    String? phone,
    String? address,
    String? imageUrl,
  }) async {
    await Future.wait([
      _storage.write(key: _keyUserId, value: id),
      _storage.write(key: _keyUserEmail, value: email),
      _storage.write(key: _keyUserRole, value: role),
      _storage.write(key: _keyFirstName, value: firstName),
      _storage.write(key: _keyLastName, value: lastName),
      if (phone != null) _storage.write(key: _keyPhone, value: phone),
      if (address != null) _storage.write(key: _keyAddress, value: address),
      if (imageUrl != null) _storage.write(key: _keyImageUrl, value: imageUrl),
    ]);
  }

  Future<Map<String, String?>> getUserData() async {
    final results = await Future.wait([
      _storage.read(key: _keyUserId),
      _storage.read(key: _keyUserEmail),
      _storage.read(key: _keyUserRole),
      _storage.read(key: _keyFirstName),
      _storage.read(key: _keyLastName),
      _storage.read(key: _keyPhone),
      _storage.read(key: _keyAddress),
      _storage.read(key: _keyImageUrl),
    ]);
    return {
      'id': results[0],
      'email': results[1],
      'role': results[2],
      'firstName': results[3],
      'lastName': results[4],
      'phone': results[5],
      'address': results[6],
      'imageUrl': results[7],
    };
  }

  Future<void> clearAll() => _storage.deleteAll();

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
