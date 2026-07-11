import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/storage/secure_storage.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:revexa/features/auth/data/models/auth_user_model.dart';

abstract interface class AuthRepository {
  Future<Result<AuthUser>> login({required String email, required String password});
  Future<Result<AuthUser>> register({
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
  Future<Result<void>> logout();
  Future<Result<void>> forgotPassword(String email);
  Future<Result<String>> verifyResetCode({required String email, required String code});
  /// Sends [idToken] to the backend and returns the authenticated user.
  Future<Result<AuthUser>> signInWithGoogle({required String idToken});
  /// Resets the password. On success emits [Result<void>] — the backend
  /// does NOT return a user or JWT after reset.
  Future<Result<void>> resetPassword({required String token, required String password});
  Future<AuthUser?> getStoredUser();
  Future<void> persistUser(AuthUser user);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final SecureStorage _storage;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required SecureStorage storage,
  })  : _remote = remote,
        _storage = storage;

  Future<void> _persistAuthUser(AuthUser user) async {
    await _storage.saveToken(user.token);
    await _storage.saveUser(
      id: user.id,
      email: user.email,
      role: user.role,
      firstName: user.firstName,
      lastName: user.lastName,
      phone: user.phone,
      address: user.address,
      imageUrl: user.imageUrl,
    );
  }

  @override
  Future<Result<AuthUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remote.login(email: email, password: password);
      await _persistAuthUser(user);
      return Success(user);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<AuthUser>> register({
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
      final user = await _remote.register(
        email: email,
        password: password,
        role: role,
        name: name,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        age: age,
        gender: gender,
        address: address,
      );
      await _persistAuthUser(user);
      return Success(user);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<AuthUser>> signInWithGoogle({required String idToken}) async {
    try {
      final user = await _remote.signInWithGoogle(idToken: idToken);
      await _persistAuthUser(user);
      return Success(user);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _remote.logout();
    } catch (_) {
      // Always clear locally even if server call fails
    } finally {
      await _storage.clearAll();
    }
    return const Success(null);
  }

  @override
  Future<Result<void>> forgotPassword(String email) async {
    try {
      await _remote.forgotPassword(email);
      return const Success(null);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<String>> verifyResetCode({
    required String email,
    required String code,
  }) async {
    try {
      final token = await _remote.verifyResetCode(email: email, code: code);
      return Success(token);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<void>> resetPassword({
    required String token,
    required String password,
  }) async {
    try {
      await _remote.resetPassword(token: token, password: password);
      // Clear stored session so the user must log in again with the new password.
      await _storage.clearAll();
      return const Success(null);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<AuthUser?> getStoredUser() async {
    final hasToken = await _storage.hasToken();
    if (!hasToken) return null;
    final data = await _storage.getUserData();
    if (data['id'] == null || data['id']!.isEmpty) return null;
    final token = await _storage.getToken() ?? '';
    return AuthUser.fromStorage(data).copyWith(token: token);
  }

  @override
  Future<void> persistUser(AuthUser user) async {
    await _storage.saveUser(
      id: user.id,
      email: user.email,
      role: user.role,
      firstName: user.firstName,
      lastName: user.lastName,
      phone: user.phone,
      address: user.address,
      imageUrl: user.imageUrl,
    );
  }
}
