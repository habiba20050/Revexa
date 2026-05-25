import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthInitial());

  /// Check if user is already logged in (called at app startup)
  Future<void> checkAuthStatus() async {
    if (isClosed) return;
    emit(const AuthChecking());
    try {
      final user = await _repository.getStoredUser();
      if (isClosed) return;
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      if (!isClosed) emit(const AuthUnauthenticated());
    }
  }

  Future<void> login({required String email, required String password}) async {
    if (isClosed) return;
    emit(const AuthLoading());
    try {
      final result = await _repository.login(email: email, password: password);
      if (isClosed) return;
      if (result is Success) {
        emit(AuthAuthenticated(result.data!));
      } else {
        emit(AuthError(result.failure!.message));
      }
    } catch (e) {
      if (!isClosed) emit(AuthError('Unexpected error: $e'));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required int age,
    required String gender,
    required String address,
  }) async {
    if (isClosed) return;
    emit(const AuthLoading());
    try {
      final result = await _repository.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        age: age,
        gender: gender,
        address: address,
      );
      if (isClosed) return;
      if (result is Success) {
        emit(AuthAuthenticated(result.data!));
      } else {
        emit(AuthError(result.failure!.message));
      }
    } catch (e) {
      if (!isClosed) emit(AuthError('Unexpected error: $e'));
    }
  }

  Future<void> logout() async {
    if (isClosed) return;
    emit(const AuthLoading());
    try {
      await _repository.logout();
    } finally {
      if (!isClosed) emit(const AuthUnauthenticated());
    }
  }

  Future<void> forgotPassword(String email) async {
    if (isClosed) return;
    emit(const AuthLoading());
    try {
      final result = await _repository.forgotPassword(email);
      if (isClosed) return;
      if (result is Success) {
        emit(const ForgotPasswordSuccess());
      } else {
        emit(AuthError(result.failure!.message));
      }
    } catch (e) {
      if (!isClosed) emit(AuthError('Unexpected error: $e'));
    }
  }
}
