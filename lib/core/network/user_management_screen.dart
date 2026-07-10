import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/network/user_management_remote_datasource.dart';
import 'package:revexa/core/network/user_management_repository.dart';
import 'package:revexa/core/network/user_management_cubit.dart';
import 'package:revexa/core/network/user_management_state.dart';
import 'package:revexa/features/auth/data/models/auth_user_model.dart';
import 'package:revexa/l10n/app_localizations.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We provide the Cubit and its dependencies here.
    // In a larger app, this would be handled by a dependency injection framework like get_it.
    return BlocProvider(
      create: (context) => UserManagementCubit(
        UserManagementRepositoryImpl(
          UserManagementRemoteDataSourceImpl(),
        ),
      )..fetchAllUsers(), // Fetch users immediately when the screen is created
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.userManagement),
        ),
        body: const UserManagementView(),
      ),
    );
  }
}

class UserManagementView extends StatelessWidget {
  const UserManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserManagementCubit, UserManagementState>(
      listener: (context, state) {
        if (state is UserManagementActionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is UserManagementError) {
          // Also show errors from actions (like delete failure) in a SnackBar
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
        }
      },
      builder: (context, state) {
        if (state is UserManagementInitial || state is UserManagementLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UserManagementLoaded) {
          if (state.users.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.noUsersFound));
          }
          // Use RefreshIndicator to allow pull-to-refresh functionality
          return RefreshIndicator(
            onRefresh: () => context.read<UserManagementCubit>().fetchAllUsers(),
            child: ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserListItem(user: user);
              },
            ),
          );
        }
        if (state is UserManagementError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${AppLocalizations.of(context)!.error}: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      context.read<UserManagementCubit>().fetchAllUsers(),
                  child: Text(AppLocalizations.of(context)!.retry),
                ),
              ],
            ),
          );
        }
        return Center(child: Text(AppLocalizations.of(context)!.unexpectedState));
      },
    );
  }
}

class UserListItem extends StatelessWidget {
  final AuthUser user;
  const UserListItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isAdmin = user.role == 'admin';

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: user.imageUrl != null ? NetworkImage(user.imageUrl!) : null,
        child: user.imageUrl == null ? const Icon(Icons.person) : null,
      ),
      title: Row(
        children: [
          Text(user.fullName),
          if (isAdmin)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.shield,
                color: AppColors.primary,
                size: 16,
              ),
            ),
        ],
      ),
      subtitle: Text(user.email),
      trailing: isAdmin
          ? null // Don't show delete button for other admins
          : IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _showDeleteConfirmation(context, user, l10n),
            ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, AuthUser user, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.deleteUserConfirmationTitle),
          content: Text('${l10n.deleteUserConfirmationBody} ${user.fullName}'),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.delete),
              onPressed: () {
                context.read<UserManagementCubit>().deleteUser(user.id);
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}