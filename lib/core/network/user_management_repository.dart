import 'package:revexa/core/error/failures.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/core/network/user_management_remote_datasource.dart';
import 'package:revexa/features/auth/data/models/auth_user_model.dart';

/// Abstract interface for the user management repository.
abstract interface class UserManagementRepository {
  /// Fetches a paginated list of all users.
  Future<Result<List<AuthUser>>> getAllUsers({int page = 1, int limit = 20});

  /// Fetches a single user by their ID.
  Future<Result<AuthUser>> getUserById(String userId);

  /// Updates a user's profile by their ID.
  Future<Result<AuthUser>> updateUser(String userId, Map<String, dynamic> data);

  /// Deletes a user by their ID.
  Future<Result<void>> deleteUser(String userId);
}

/// Implementation of the [UserManagementRepository].
class UserManagementRepositoryImpl implements UserManagementRepository {
  final UserManagementRemoteDataSource remoteDataSource;

  UserManagementRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<AuthUser>>> getAllUsers({int page = 1, int limit = 20}) async {
    try {
      final users = await remoteDataSource.getAllUsers(page: page, limit: limit);
      return Success(users);
    } catch (e) {
      return ResultFailure(ServerFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<AuthUser>> getUserById(String userId) async {
    try {
      final user = await remoteDataSource.getUserById(userId);
      return Success(user);
    } catch (e) {
      return ResultFailure(ServerFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> deleteUser(String userId) async {
    try {
      await remoteDataSource.deleteUser(userId);
      return const Success(null);
    } catch (e) {
      return ResultFailure(ServerFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<AuthUser>> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      final user = await remoteDataSource.updateUser(userId, data);
      return Success(user);
    } catch (e) {
      return ResultFailure(ServerFailure.fromException(e as Exception));
    }
  }
}