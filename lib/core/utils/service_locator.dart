import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/core/storage/secure_storage.dart';
import 'package:revexa/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:revexa/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:revexa/features/categories/categories.dart';
import 'package:revexa/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:revexa/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:revexa/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:revexa/features/products/data/datasources/products_remote_datasource.dart';
import 'package:revexa/features/products/data/repositories/products_repository_impl.dart';
import 'package:revexa/features/products/presentation/cubit/products_cubit.dart';
import 'package:revexa/shared/theme/theme_cubit.dart';
import 'package:revexa/shared/locale/locale_cubit.dart';

/// Simple service locator — no external package required.
class ServiceLocator {
  ServiceLocator._();
  static final ServiceLocator _instance = ServiceLocator._();
  static ServiceLocator get instance => _instance;

  late final AuthCubit authCubit;
  late final ProductsCubit productsCubit;
  late final OrdersCubit ordersCubit;
  late final CategoriesCubit categoriesCubit;
  late final ThemeCubit themeCubit;
  late final LocaleCubit localeCubit;

  void initialize({void Function()? onUnauthorized}) {
    // Core
    DioClient.instance.init(onUnauthorized: onUnauthorized);

    // Auth
    final authDataSource = AuthRemoteDataSourceImpl();
    final authRepo = AuthRepositoryImpl(
      remote: authDataSource,
      storage: SecureStorage.instance,
    );
    authCubit = AuthCubit(authRepo);

    // Products
    final productsDataSource = ProductsRemoteDataSourceImpl();
    final productsRepo = ProductsRepositoryImpl(productsDataSource);
    productsCubit = ProductsCubit(productsRepo);

    // Orders
    final ordersDataSource = OrdersRemoteDataSourceImpl();
    final ordersRepo = OrdersRepositoryImpl(ordersDataSource);
    ordersCubit = OrdersCubit(ordersRepo);

    // Categories
    final categoriesDataSource = CategoriesRemoteDataSource();
    final categoriesRepo = CategoriesRepository(categoriesDataSource);
    categoriesCubit = CategoriesCubit(categoriesRepo);

    // Theme
    themeCubit = ThemeCubit();
    localeCubit = LocaleCubit();
  }
}
