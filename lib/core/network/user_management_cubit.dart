import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/auth/data/models/auth_user_model.dart';
import 'package:revexa/core/network/user_management_repository.dart';
import 'package:revexa/core/network/user_management_state.dart';

class UserManagementCubit extends Cubit<UserManagementState> {
  final UserManagementRepository _repository;

  UserManagementCubit(this._repository) : super(UserManagementInitial());

  Future<void> fetchAllUsers({int page = 1, int limit = 50}) async {
    emit(UserManagementLoading());
    final result = await _repository.getAllUsers(page: page, limit: limit);

    if (isClosed) return;

    if (result is Success) {
      emit(UserManagementLoaded(result.data!));
    } else {
      emit(UserManagementError(result.failure!.message));
    }
  }

  Future<void> deleteUser(String userId) async {
    final currentState = state;
    List<AuthUser> originalUsers = [];

    // Optimistically update the UI
    if (currentState is UserManagementLoaded) {
      originalUsers = List.from(currentState.users);
      final updatedUsers = currentState.users.where((user) => user.id != userId).toList();
      emit(UserManagementLoaded(updatedUsers));
    } else {
      // If the state is not loaded, we can't do an optimistic update.
      // Show loading and refetch after the operation.
      emit(UserManagementLoading());
    }

    final result = await _repository.deleteUser(userId);

    if (isClosed) return;

    // After the operation, decide what to show.
    if (result is ResultFailure<void>) {
      // On failure, revert the UI to its state before the optimistic update.
      if (currentState is UserManagementLoaded) {
        // Revert to the original list and then emit the error for the listener.
        // The UI will rebuild with the original list.
        emit(UserManagementLoaded(originalUsers)); 
      }
      // Emit the error state for the listener to show a message (e.g., SnackBar).
      emit(UserManagementError(result.failure.message));
    } else {
      // On success, the optimistic update is now the correct state.
      // The UI is already showing the updated list.
      // We emit a success event for the listener (e.g., SnackBar).
      emit(const UserManagementActionSuccess('User deleted successfully.'));
    }
  }
}