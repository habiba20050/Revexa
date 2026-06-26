import 'package:equatable/equatable.dart';
import 'package:revexa/core/utils/image_url_utils.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String token;
  final String? phone;
  final String? address;
  final String? imageUrl;

  const AuthUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.token,
    this.phone,
    this.address,
    this.imageUrl,
  });

  String get fullName {
    final combined = '$firstName $lastName'.trim();
    return combined.isEmpty ? email.split('@').first : combined;
  }

  AuthUser copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? role,
    String? token,
    String? phone,
    String? address,
    String? imageUrl,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      token: token ?? this.token,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory AuthUser.fromLoginJson(Map<String, dynamic> json, String token) {
    final user = json['user'] as Map<String, dynamic>;
    return AuthUser.fromUserMap(user, token: token);
  }

  factory AuthUser.fromRegisterJson(Map<String, dynamic> json, String token) {
    final user = json['user'] as Map<String, dynamic>;
    return AuthUser.fromUserMap(user, token: token);
  }

  factory AuthUser.fromUserMap(Map<String, dynamic> json, {required String token}) {
    final name = json['name']?.toString().trim() ?? '';
    var first = json['firstName']?.toString() ?? '';
    var last = json['lastName']?.toString() ?? '';
    if (first.isEmpty && last.isEmpty && name.isNotEmpty) {
      final parts = name.split(RegExp(r'\s+'));
      first = parts.first;
      if (parts.length > 1) last = parts.sublist(1).join(' ');
    }

    return AuthUser(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: first,
      lastName: last,
      role: json['role']?.toString() ?? 'user',
      token: token,
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
      imageUrl: ImageUrlUtils.resolve(
        json['image'] ?? json['imageUrl'] ?? json['avatar'],
      ),
    );
  }

  factory AuthUser.fromStorage(Map<String, String?> data) {
    return AuthUser(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      role: data['role'] ?? 'user',
      token: '',
      phone: data['phone'],
      address: data['address'],
      imageUrl: ImageUrlUtils.resolve(data['imageUrl']),
    );
  }

  @override
  List<Object?> get props => [id, email, firstName, lastName, role, token, phone, address, imageUrl];
}
