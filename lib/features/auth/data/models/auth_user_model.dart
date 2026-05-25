import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String token;

  const AuthUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.token,
  });

  String get fullName => '$firstName $lastName';

  factory AuthUser.fromLoginJson(Map<String, dynamic> json, String token) {
    final user = json['user'] as Map<String, dynamic>;
    return AuthUser(
      id: user['id']?.toString() ?? '',
      email: user['email']?.toString() ?? '',
      firstName: user['firstName']?.toString() ?? '',
      lastName: user['lastName']?.toString() ?? '',
      role: user['role']?.toString() ?? 'user',
      token: token,
    );
  }

  factory AuthUser.fromRegisterJson(Map<String, dynamic> json, String token) {
    final user = json['user'] as Map<String, dynamic>;
    return AuthUser(
      id: user['id']?.toString() ?? '',
      email: user['email']?.toString() ?? '',
      firstName: user['firstName']?.toString() ?? '',
      lastName: user['lastName']?.toString() ?? '',
      role: 'user',
      token: token,
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
    );
  }

  @override
  List<Object?> get props => [id, email, firstName, lastName, role, token];
}
