import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:revexa/l10n/app_localizations.dart';
import 'package:revexa/core/constants/app_routes.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/theme/app_theme.dart';
import 'package:revexa/core/utils/service_locator.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_state.dart';
import 'package:revexa/features/categories/categories.dart';
import 'package:revexa/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:revexa/features/products/presentation/cubit/products_cubit.dart';
import 'package:revexa/features/profile/presentation/screens/addresses_screen.dart';
import 'package:revexa/features/services/presentation/cubit/services_cubit.dart';
import 'package:revexa/features/updates/presentation/cubit/news_cubit.dart';
import 'package:revexa/shared/locale/locale_cubit.dart';
import 'package:revexa/shared/theme/theme_cubit.dart';

// Auth screens
import 'package:revexa/features/splash/presentation/screens/splash_screen.dart';
import 'package:revexa/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:revexa/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:revexa/features/auth/presentation/screens/register_screen.dart';
import 'package:revexa/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:revexa/features/auth/presentation/screens/reset_password_screen.dart';

// Main
import 'package:revexa/features/home/presentation/screens/home_screen.dart';

// New feature screens
import 'package:revexa/features/services/presentation/screens/services_screen.dart';
import 'package:revexa/features/services/presentation/screens/service_detail_screen.dart';
import 'package:revexa/features/services/presentation/screens/maintenance_detail_screen.dart';
import 'package:revexa/features/services/presentation/screens/mobile_wash_detail_screen.dart';
import 'package:revexa/features/services/presentation/screens/oil_service_detail_screen.dart';
import 'package:revexa/features/services/presentation/screens/tires_detail_screen.dart';
import 'package:revexa/features/services/presentation/screens/battery_detail_screen.dart';
import 'package:revexa/features/workshops/presentation/screens/nearby_workshops_screen.dart';
import 'package:revexa/features/orders/presentation/screens/create_order_screen.dart';
import 'package:revexa/features/orders/presentation/screens/order_detail_screen.dart';
import 'package:revexa/features/profile/presentation/screens/profile_screen.dart';
import 'package:revexa/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:revexa/features/vehicles/presentation/screens/my_vehicles_screen.dart';
import 'package:revexa/features/billing/presentation/screens/billing_screen.dart';
import 'package:revexa/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:revexa/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:revexa/features/bookings/presentation/screens/bookings_screen.dart';
// No settings_screen import needed since settings are now in profile_screen.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initial system UI overlay — will be updated reactively inside BlocBuilder.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  ServiceLocator.instance.initialize(
    onUnauthorized: () => ServiceLocator.instance.authCubit.logout(),
  );

  await Future.wait([
    ServiceLocator.instance.themeCubit.loadTheme(),
    ServiceLocator.instance.localeCubit.loadLocale(),
  ]);

  runApp(const RevexaApp());
}

class RevexaApp extends StatelessWidget {
  const RevexaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sl = ServiceLocator.instance;
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: sl.themeCubit),
        BlocProvider<LocaleCubit>.value(value: sl.localeCubit),
        BlocProvider<AuthCubit>.value(value: sl.authCubit),
        BlocProvider<ProductsCubit>.value(value: sl.productsCubit),
        BlocProvider<OrdersCubit>.value(value: sl.ordersCubit),
        BlocProvider<CategoriesCubit>.value(value: sl.categoriesCubit),
        BlocProvider<ServicesCubit>.value(value: sl.servicesCubit),
        BlocProvider<NewsCubit>.value(value: sl.newsCubit),
        BlocProvider<NotificationsCubit>.value(value: sl.notificationsCubit),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              final isDark = themeState.mode == AppThemeMode.dark ||
                  (themeState.mode == AppThemeMode.system &&
                      WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark);
              AppColors.isDark = isDark;
              // Update system status-bar icon brightness reactively.
              // Dark mode → light icons (Brightness.light) on dark background.
              // Light mode → dark icons (Brightness.dark) on light background.
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness:
                      isDark ? Brightness.light : Brightness.dark,
                ),
              );

              return MaterialApp(
                title: 'Revexa',
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en'),
                  Locale('ar'),
                ],
                locale: locale,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeState.themeMode,
                themeAnimationDuration: Duration.zero,
                initialRoute: AppRoutes.splash,
                routes: {
                  AppRoutes.splash: (_) => const AppStartupWrapper(),
                  AppRoutes.onboardingBooking: (_) => const OnboardingScreen(),
                  AppRoutes.signIn: (_) => const SignInScreen(),
                  AppRoutes.register: (_) => const RegisterScreen(),
                  AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
                  AppRoutes.resetPassword: (context) {
                    final token = ModalRoute.of(context)?.settings.arguments as String?;
                    return ResetPasswordScreen(initialToken: token);
                  },
                  AppRoutes.home: (_) => const HomeScreen(),
                  // New screens
                  AppRoutes.services: (_) => const ServicesScreen(),
                  AppRoutes.nearbyWorkshops: (_) => const NearbyWorkshopsScreen(),
                  AppRoutes.serviceDetail: (_) => const ServiceDetailScreen(),
                  AppRoutes.maintenanceDetail: (_) => const MaintenanceDetailScreen(),
                  AppRoutes.mobileWashDetail: (_) => const MobileWashDetailScreen(),
                  AppRoutes.oilServiceDetail: (_) => const OilServiceDetailScreen(),
                  AppRoutes.tiresDetail: (_) => const TiresDetailScreen(),
                  AppRoutes.batteryDetail: (_) => const BatteryDetailScreen(),
                  AppRoutes.createOrder: (_) => const CreateOrderScreen(),
                  AppRoutes.orderDetail: (_) => const OrderDetailScreen(),
                  AppRoutes.profile: (_) => const ProfileScreen(),
                  AppRoutes.editProfile: (_) => const EditProfileScreen(),
                  AppRoutes.addresses: (_) => const AddressesScreen(),
                  AppRoutes.myVehicles: (_) => const MyVehiclesScreen(),
                  AppRoutes.billing: (_) => const BillingScreen(),
                  AppRoutes.notifications: (_) => const NotificationsScreen(),
                  AppRoutes.bookings: (_) => const BookingsScreen(),
                  AppRoutes.settings: (_) => const ProfileScreen(),
                },
              );
            },
          );
        },
      ),
    );
  }
}

class AppStartupWrapper extends StatefulWidget {
  const AppStartupWrapper({super.key});

  @override
  State<AppStartupWrapper> createState() => _AppStartupWrapperState();
}

class _AppStartupWrapperState extends State<AppStartupWrapper> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.onboardingBooking);
        }
      },
      child: const SplashScreen(),
    );
  }
}
