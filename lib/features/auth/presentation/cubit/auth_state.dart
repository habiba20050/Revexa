import 'package:equatable/equatable.dart';
import 'package:revexa/features/auth/data/models/auth_user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthChecking extends AuthState {
  const AuthChecking();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final AuthUser user;
  const AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthSuccess extends AuthState {
  final AuthUser user;
  final String message;
  const AuthSuccess(this.user, {this.message = ''});
  @override
  List<Object?> get props => [user, message];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

class ForgotPasswordSuccess extends AuthState {
  const ForgotPasswordSuccess();
}

class VerifyResetCodeSuccess extends AuthState {
  /// The short-lived reset token returned by POST /auth/verify-reset-code.
  final String resetToken;
  const VerifyResetCodeSuccess(this.resetToken);
  @override
  List<Object?> get props => [resetToken];
}
