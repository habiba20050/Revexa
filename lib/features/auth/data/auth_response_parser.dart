import 'package:revexa/features/auth/data/models/auth_user_model.dart';

class AuthResponseParser {
  AuthResponseParser._();

  static AuthUser parse(dynamic body) {
    if (body is! Map) {
      throw const FormatException('Invalid authentication response');
    }
    final map = Map<String, dynamic>.from(body);

    // Shape 1: { data: { token, user: {...} } }
    if (map['data'] is Map) {
      final data = Map<String, dynamic>.from(map['data'] as Map);
      final token = data['token']?.toString() ?? '';
      // Nested user object inside data
      if (data['user'] is Map) {
        return AuthUser.fromUserMap(
          Map<String, dynamic>.from(data['user'] as Map),
          token: token,
        );
      }
      // User fields directly on data
      if (token.isNotEmpty || data['email'] != null || data['_id'] != null) {
        return AuthUser.fromUserMap(data, token: token);
      }
    }

    // Shape 2: { token, user: {...} }
    final token = map['token']?.toString() ?? '';
    if (map['user'] is Map) {
      return AuthUser.fromUserMap(
        Map<String, dynamic>.from(map['user'] as Map),
        token: token,
      );
    }

    // Shape 3: { token, ...userFields }
    if (token.isNotEmpty) {
      return AuthUser.fromUserMap(map, token: token);
    }

    throw const FormatException('Authentication response did not include user data');
  }
}
