import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:revexa/core/constants/app_constants.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/auth/data/models/auth_user_model.dart';
import 'package:revexa/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_state.dart';
import 'package:revexa/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:revexa/core/utils/image_url_utils.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  final ProfileRemoteDataSource _profileRemote;

  /// Single GoogleSignIn instance configured for both platforms.
  /// On web: clientId is mandatory (FedCM / OAuth popup).
  /// On mobile: clientId is ignored by the plugin; idToken comes from Google Play Services.
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email', 'profile', 'openid'],
    clientId: kIsWeb ? AppConstants.googleWebClientId : null,
  );

  AuthCubit(this._repository, {ProfileRemoteDataSource? profileRemote})
      : _profileRemote = profileRemote ?? ProfileRemoteDataSourceImpl(),
        super(const AuthInitial());

  // ─────────────────────────────────────────────────────────────
  // Auth status
  // ─────────────────────────────────────────────────────────────

  /// Check if user is already logged in (called at app startup).
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

  // ─────────────────────────────────────────────────────────────
  // Email / password
  // ─────────────────────────────────────────────────────────────

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

  /// يسجل مستخدمًا جديدًا (شخصيًا أو شركة).
  ///
  /// يجمع كل المعلمات في خريطة واحدة ويرسلها إلى الـ repository.
  /// المعلمات غير المطلوبة (مثل `firstName` لحساب الشركة) يجب أن تكون `null`.
  Future<void> register({
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
    if (isClosed) return;
    emit(const AuthLoading());
    try {
      final result = await _repository.register(
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

  // ─────────────────────────────────────────────────────────────
  // Google Sign-In  (جذري ومبسط)
  // ─────────────────────────────────────────────────────────────

  Future<void> signInWithGoogle() async {
    if (isClosed) return;
    emit(const AuthLoading());

    try {
      // 1. Trigger the Google sign-in UI (works on mobile + web).
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the picker.
        if (!isClosed) emit(const AuthUnauthenticated());
        return;
      }

      // 2. Retrieve the auth tokens from the signed-in account.
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        // idToken is expected on mobile always.
        // On web it depends on FedCM support in the browser.
        if (!isClosed) {
          emit(const AuthError(
            'Google Sign-In did not return an ID token. '
            'Make sure you are running on a supported platform with '
            'the correct OAuth client ID configured.',
          ));
        }
        return;
      }

      // 3. Send idToken to the Revexa backend POST /auth/google.
      final result = await _repository.signInWithGoogle(idToken: idToken);

      if (isClosed) return;
      if (result is Success) {
        emit(AuthAuthenticated(result.data!));
      } else {
        emit(AuthError(result.failure!.message));
      }
    } catch (e) {
      if (!isClosed) emit(AuthError('Google Sign In failed: $e'));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Logout
  // ─────────────────────────────────────────────────────────────

  Future<void> logout() async {
    if (isClosed) return;
    emit(const AuthLoading());
    try {
      try {
        await _googleSignIn.signOut();
      } catch (_) {
        // Continue logout even if Google sign-out fails.
      }
      await _repository.logout();
    } finally {
      if (!isClosed) emit(const AuthUnauthenticated());
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Profile helpers
  // ─────────────────────────────────────────────────────────────

  Future<void> refreshProfile() async {
    if (isClosed) return;
    final current = state;
    if (current is! AuthAuthenticated) return;
    try {
      final user = await _profileRemote.getProfile();
      await _repository.persistUser(user);
      if (!isClosed) emit(AuthAuthenticated(user.copyWith(token: current.user.token)));
    } catch (_) {
      // Keep cached user if profile fetch fails
    }
  }

  Future<void> applyProfileUpdate(AuthUser user) async {
    if (isClosed) return;
    ImageUrlUtils.avatarCacheBuster =
        DateTime.now().millisecondsSinceEpoch.toString();
    final current = state;
    final token =
        current is AuthAuthenticated ? current.user.token : user.token;
    final updated = user.copyWith(token: token);
    await _repository.persistUser(updated);
    if (!isClosed) emit(AuthAuthenticated(updated));
  }

  // ─────────────────────────────────────────────────────────────
  // Password reset flow
  // ─────────────────────────────────────────────────────────────

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

  Future<void> verifyResetCode({
    required String email,
    required String code,
  }) async {
    if (isClosed) return;
    emit(const AuthLoading());
    try {
      final result =
          await _repository.verifyResetCode(email: email, code: code);
      if (isClosed) return;
      if (result is Success) {
        emit(VerifyResetCodeSuccess(result.data!));
      } else {
        emit(AuthError(result.failure!.message));
      }
    } catch (e) {
      if (!isClosed) emit(AuthError('Unexpected error: $e'));
    }
  }

  /// Resets the user's password using the [token] from [verifyResetCode].
  ///
  /// On success the backend returns a message only (no user / JWT).
  /// We emit [ResetPasswordSuccess] so the UI can navigate to sign-in.
  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    if (isClosed) return;
    emit(const AuthLoading());
    try {
      final result =
          await _repository.resetPassword(token: token, password: password);
      if (isClosed) return;
      if (result is Success) {
        emit(const ResetPasswordSuccess());
      } else {
        emit(AuthError(result.failure!.message));
      }
    } catch (e) {
      if (!isClosed) emit(AuthError('Unexpected error: $e'));
    }
  }
}
