import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/auth/data/models/auth_user_model.dart';
import 'package:revexa/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_state.dart';
import 'package:revexa/features/profile/data/datasources/profile_remote_datasource.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  final ProfileRemoteDataSource _profileRemote;
  final GoogleSignIn _googleSignIn = kIsWeb
      ? GoogleSignIn(
          clientId: '865041538115-o3j0ldik5rup9h8caslsv6blte24uju6.apps.googleusercontent.com',
          scopes: <String>['email', 'profile', 'openid'],
          forceCodeForRefreshToken: true, // Request serverAuthCode for web
        )
      : GoogleSignIn(
          scopes: <String>['email', 'profile', 'openid'],
        );

  AuthCubit(this._repository, {ProfileRemoteDataSource? profileRemote})
      : _profileRemote = profileRemote ?? ProfileRemoteDataSourceImpl(),
        super(const AuthInitial()) {
    // تفعيل الاستماع التلقائي في الويب فقط عند بدء عمل الـ Cubit
    if (kIsWeb) {
      _setupWebGoogleSignInListener();
    }
  }

  /// إعداد مستمع خاص بالويب لجلب التوكنات بأمان عند استخدام الـ Web Sign In
  void _setupWebGoogleSignInListener() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? googleUser) async {
      if (googleUser == null) return;

      if (!isClosed) emit(const AuthLoading());

      try {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final String? accessToken = googleAuth.accessToken;
        final String? idToken = googleAuth.idToken;

        if (accessToken == null) {
          if (!isClosed) emit(const AuthError('Failed to get Google Access Token on Web'));
          return;
        }

        // On web: use serverAuthCode or idToken (idToken is typically null on web)
        // On native: idToken is usually available
        final String? authToken = idToken ?? googleAuth.serverAuthCode;
        if (authToken == null || authToken.isEmpty) {
          if (!isClosed) emit(const AuthError('Failed to get Google authentication token (idToken/serverAuthCode) on Web'));
          return;
        }

        final result = await _repository.signInWithGoogle(
          accessToken: accessToken,
          idToken: authToken,
        );

        if (isClosed) return;
        if (result is Success) {
          emit(AuthAuthenticated(result.data!));
        } else {
          emit(AuthError(result.failure!.message));
        }
      } catch (e) {
        if (!isClosed) emit(AuthError('Google Web Sign In verification failed: $e'));
      }
    });
  }

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

  Future<void> signInWithGoogle() async {
    if (isClosed) return;
    emit(const AuthLoading());
    try {
      if (kIsWeb) {
        // For web: FedCM returns a JWT credential
        // First try silent sign-in, then fall back to interactive
        final user = await _googleSignIn.signInSilently();
        
        // After sign-in, wait a moment for the listener to process
        await Future.delayed(const Duration(milliseconds: 300));
        
        // If listener didn't handle it, manually process the current user
        if (state is! AuthAuthenticated && !isClosed) {
          final currentUser = _googleSignIn.currentUser;
          if (currentUser != null) {
            try {
              final googleAuth = await currentUser.authentication;
              final idToken = googleAuth.idToken;
              
              // On web: FedCM provides idToken (JWT); accessToken may be null
              if (idToken != null && idToken.isNotEmpty && !isClosed) {
                final result = await _repository.signInWithGoogle(
                  accessToken: idToken, // Pass JWT as accessToken
                  idToken: idToken,     // Also as idToken
                );
                if (result is Success) {
                  emit(AuthAuthenticated(result.data!));
                } else {
                  emit(AuthError(result.failure!.message));
                }
              } else {
                if (!isClosed) emit(const AuthError('Failed to get Google idToken on Web (FedCM)'));
              }
            } catch (e) {
              if (!isClosed) emit(AuthError('Failed to process FedCM auth: $e'));
            }
          } else if (user == null) {
            // Silent sign-in failed, try interactive
            await _googleSignIn.signIn();
          }
        }
        return;
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        if (!isClosed) emit(const AuthUnauthenticated());
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      if (accessToken == null) {
        if (!isClosed) emit(const AuthError('Failed to get Google Access Token'));
        return;
      }

      // On native platforms and web: prefer idToken, fallback to serverAuthCode
      final String? authToken = idToken ?? googleAuth.serverAuthCode;
      if (authToken == null || authToken.isEmpty) {
        if (!isClosed) emit(const AuthError('Failed to get Google authentication token (idToken/serverAuthCode)'));
        return;
      }

      final result = await _repository.signInWithGoogle(
        accessToken: accessToken,
        idToken: authToken,
      );

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
    final current = state;
    final token = current is AuthAuthenticated ? current.user.token : user.token;
    final updated = user.copyWith(token: token);
    await _repository.persistUser(updated);
    if (!isClosed) emit(AuthAuthenticated(updated));
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