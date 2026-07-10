import 'package:equatable/equatable.dart';
import 'package:revexa/features/auth/data/models/auth_user_model.dart';

abstract class UserManagementState extends Equatable {
  const UserManagementState();

  @override
  List<Object?> get props => [];
}

class UserManagementInitial extends UserManagementState {}

class UserManagementLoading extends UserManagementState {}

class UserManagementLoaded extends UserManagementState {
  final List<AuthUser> users;

  const UserManagementLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserManagementError extends UserManagementState {
  final String message;

  const UserManagementError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserManagementActionSuccess extends UserManagementState {
  final String message;

  const UserManagementActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}