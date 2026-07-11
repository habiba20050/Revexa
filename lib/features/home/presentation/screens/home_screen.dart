// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/constants/app_constants.dart';
import 'package:revexa/core/constants/app_routes.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_state.dart';
import 'package:revexa/features/products/presentation/cubit/products_cubit.dart';
import 'package:revexa/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:revexa/shared/locale/locale_cubit.dart';
import 'package:revexa/shared/theme/theme_cubit.dart';
import 'package:revexa/shared/widgets/app_image.dart';
import 'package:revexa/shared/widgets/app_logo.dart';
import 'package:revexa/shared/widgets/app_bottom_nav_bar.dart';
import 'package:revexa/features/bookings/presentation/screens/bookings_screen.dart';
import 'package:revexa/features/updates/presentation/screens/updates_screen.dart';
import 'package:revexa/features/services/presentation/screens/services_screen.dart';
import 'package:revexa/features/profile/presentation/screens/profile_screen.dart';
import 'package:revexa/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:revexa/l10n/app_localizations.dart';
import 'package:revexa/features/home/presentation/screens/company_dashboard_screen.dart';
import 'package:revexa/features/chatbot/presentation/widgets/chatbot_fab.dart';
import 'package:revexa/features/ads/presentation/cubit/ads_cubit.dart';
import 'package:revexa/features/home/presentation/widgets/promotional_offers_slider.dart';

/// الشاشة الرئيسية للتطبيق.
/// تحتوي على الـ Bottom Navigation Bar وتدير التنقل بين الـ tabs.
/// تستخدم [MultiBlocListener] للاستجابة لتغييرات الثيم، اللغة، وحالة الـ Auth.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// التاب النشط حالياً في الـ Bottom Navigation.
  NavTab _activeTab = NavTab.home;

  /// ينتقل إلى [tab] المحدد.
  void _goToTab(NavTab tab) {
    setState(() {
      _activeTab = tab;
    });
  }

  @override
  void initState() {
    super.initState();
    // نحمّل البيانات بعد اكتمال بناء الـ Widget tree أول مرة.
    // postFrameCallback يضمن إن الـ context جاهز قبل ما نقرأ منه.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsCubit>().loadProducts();
      context.read<OrdersCubit>().loadOrders();
      context.read<AdsCubit>().loadAds();
    });
  }

  /// يرجع الـ Widget المناسب لكل تاب نشط.
  /// يستخدم switch على [_activeTab] لتحديد أي شاشة يعرضها.
  Widget _buildBody() {
    switch (_activeTab) {
      case NavTab.home:
        return _HomeBody(
          onProfileTap: () => _goToTab(NavTab.settings),
        );
      case NavTab.services:
        return ServicesScreen(
          onBackToHome: () => _goToTab(NavTab.home),
          onOpenSettings: () => _goToTab(NavTab.settings),
          initialQuery: null,
        );
      case NavTab.bookings:
        return const BookingsBody();
      case NavTab.updates:
        return UpdatesBody(onBackToHome: () => _goToTab(NavTab.home));
      case NavTab.settings:
        return ProfileScreen(onBackToHome: () => _goToTab(NavTab.home));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Force full HomeScreen subtree rebuild when theme changes.
        // Without this, AppColors.* static values are read by widgets
        // that only rebuild on their own state changes, not on
        // AppColors.isDark mutation. This causes stale colors after
        // theme switch until the user interacts with the screen.
        BlocListener<ThemeCubit, ThemeState>(
          listener: (context, _) => setState(() {}),
        ),
        // Same for locale — forces text using AppLocalizations to re-render.
        BlocListener<LocaleCubit, Locale>(
          listener: (context, _) => setState(() {}),
        ),
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              Navigator.pushReplacementNamed(context, AppRoutes.signIn);
            }
          },
        ),
      ],
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          // التحقق من دور المستخدم
          final isCompany = state is AuthAuthenticated && state.user.role == 'company';

          // إذا كان المستخدم شركة، اعرض لوحة التحكم الخاصة به
          if (isCompany) {
            return CompanyDashboardScreen();
          }

          // وإلا، اعرض الواجهة الرئيسية العادية للمستخدم
          return PopScope(
            canPop: _activeTab == NavTab.home,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              _goToTab(NavTab.home);
            },
            child: Scaffold(
              extendBody: true,
              backgroundColor: AppColors.background,
              body: Stack(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: KeyedSubtree(
                      key: ValueKey(_activeTab),
                      child: _buildBody(),
                    ),
                  ),
                  if (_activeTab == NavTab.home)
                    const Positioned(
                      right: 16,
                      bottom: 100,
                      child: ChatbotFab(),
                    ),
                ],
              ),
              bottomNavigationBar: AppBottomNavBar(
                activeTab: _activeTab,
                onTabChanged: (tab) => _goToTab(tab),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Home Body ────────────────────────────────────────────────────────────────

/// الجسم الرئيسي لشاشة Home.
/// يعرض محتوى الصفحة: Greeting، Search، Vehicle Card، Services، وPromo.
/// يدعم layout مختلف بين الموبايل (Column) والتابلت (Row بعمودين).
class _HomeBody extends StatelessWidget {
  /// Callback لما المستخدم يضغط على الأفاتار في الـ AppBar.
  final VoidCallback? onProfileTap;

  const _HomeBody({this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          context.read<ProductsCubit>().loadProducts(),
          context.read<OrdersCubit>().loadOrders(),
          context.read<AuthCubit>().checkAuthStatus(),
          context.read<AdsCubit>().loadAds(),
        ]);
      },
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _HomeAppBar(onProfileTap: onProfileTap),
                const SizedBox(height: 8),
                const _GreetingBanner(),
                const SizedBox(height: 20),
                const PromotionalOffersSlider(),
                const SizedBox(height: 24),
                const _ServicesSection(),
                const SizedBox(height: 24),
                const AdsHorizontalCarousel(),
                _ActiveBookingCard(topPadding: 16),
                const SizedBox(height: 16),
                const _PromoBanner(),
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

/// شريط التطبيق العلوي في شاشة Home.
/// يعرض شعار Revexa، أيقونة الإشعارات مع badge، وأفاتار المستخدم.
class _HomeAppBar extends StatelessWidget {
  /// Callback لما المستخدم يضغط على الأفاتار.
  final VoidCallback? onProfileTap;

  const _HomeAppBar({this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        return Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 12,
            left: 0, right: 0, bottom: 12,
          ),
          child: Row(
            children: [
              AppLogo.mini(),
              const SizedBox(width: 12),
              Text('Revexa',
                  style: GoogleFonts.urbanist(
                      fontSize: 22, fontWeight: FontWeight.w700,
                      letterSpacing: -0.3, color: AppColors.primary)),
              const Spacer(),
              // Notifications bell
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
                child: Container(
                  width: 40, height: 40,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: BlocBuilder<NotificationsCubit, NotificationsState>(
                    builder: (context, state) {
                      final hasUnread = state.notifications.any((n) => !n.isRead);
                      return Stack(alignment: Alignment.center, children: [
                        Icon(Icons.notifications_outlined,
                            color: AppColors.onSurface, size: 22),
                        if (hasUnread)
                          Positioned(
                            top: 8, right: 8,
                            child: Container(
                                width: 8, height: 8,
                                decoration: BoxDecoration(
                                    color: AppColors.error, shape: BoxShape.circle)),
                          ),
                      ]);
                    },
                  ),
                ),
              ),
              // Avatar
              GestureDetector(
                onTap: onProfileTap ?? () => Navigator.pushNamed(context, AppRoutes.profile),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.10),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.20), width: 2),
                  ),
                  child: AppCircleAvatar(
                    imageUrl: user?.imageUrl,
                    radius: 20,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.10),
                    fallback: Text(
                      user?.firstName.isNotEmpty == true ? user!.firstName[0].toUpperCase() : 'U',
                      style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// بانر الترحيب الذي يعرض اسم المستخدم وتحية مناسبة للوقت (صباح/مساء/ليل).
/// يعرض أيضاً بادج "Gold Member" على اليمين.
class _GreetingBanner extends StatelessWidget {
  const _GreetingBanner();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final name = state is AuthAuthenticated ? state.user.firstName : 'Driver';
        final hour = DateTime.now().hour;
        final l10n = AppLocalizations.of(context)!;
        final greeting = hour < 12 ? l10n.goodMorning : hour < 17 ? l10n.goodAfternoon : l10n.goodEvening;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(greeting,
                    style: GoogleFonts.urbanist(fontSize: 13, color: AppColors.onSurfaceVariant),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('$name 👋',
                    style: GoogleFonts.urbanist(
                        fontSize: 22, fontWeight: FontWeight.w800,
                        color: AppColors.onSurface, letterSpacing: -0.3),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ]),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Icon(Icons.workspace_premium, color: AppColors.primary, size: 16),
                const SizedBox(width: 4),
                Text(AppLocalizations.of(context)!.goldMember,
                    style: GoogleFonts.urbanist(
                        fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ]),
            ),
          ],
        );
      },
    );
  }
}

// Deleted _VehicleHealthCard and _StatBar widgets since they are replaced by the PromotionalOffersSlider

// Deleted _QuickActionsRow and _QuickAction widgets

/// قسم "Our Services" — يعرض شبكة (Grid) من الخدمات الثابتة.
/// القائمة ثابتة دائماً ولا تتغير بناءً على استجابة الـ API.
class _ServicesSection extends StatelessWidget {
  const _ServicesSection();

  // Static service catalogue — always displayed, regardless of API state.
  // Products API is used only for dynamic data (prices, images) in the future.
  // The services list must NEVER be gated on an empty products response.
  static const _staticServices = [
    _HomeServiceItem(icon: Icons.map_rounded, title: 'Nearby Workshops', subtitle: 'Find repair shops', route: AppRoutes.nearbyWorkshops),
    _HomeServiceItem(icon: Icons.local_car_wash_rounded, title: 'Mobile Wash', subtitle: 'Coming to you', route: AppRoutes.mobileWashDetail),
    _HomeServiceItem(icon: Icons.build_rounded, title: 'Maintenance', subtitle: 'Expert care', route: AppRoutes.maintenanceDetail),
    _HomeServiceItem(icon: Icons.local_gas_station_outlined, title: 'Energy', subtitle: 'Fuel & Charge', route: AppRoutes.services),
    _HomeServiceItem(icon: Icons.settings_outlined, title: 'Parts', subtitle: 'Genuine kits', route: AppRoutes.services),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Our Services',
              style: GoogleFonts.urbanist(
                  fontSize: 18, fontWeight: FontWeight.w700,
                  color: AppColors.onSurface, letterSpacing: -0.2)),
          GestureDetector(
            onTap: () {
              final homeState = context.findAncestorStateOfType<_HomeScreenState>();
              if (homeState != null) {
                homeState._goToTab(NavTab.services);
              } else {
                Navigator.pushNamed(context, AppRoutes.services);
              }
            },
            child: Text('Explore all',
                style: GoogleFonts.urbanist(
                    fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ),
        ]),
        const SizedBox(height: 16),
        // Static service grid — always visible.
        // These are navigation entry points, not data-driven cards.
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: _staticServices
              .map((s) => _ServiceCard(item: s))
              .toList(),
        ),
      ],
    );
  }
}

/// كارت خدمة واحدة داخل [_ServicesSection].
/// يعرض أيقونة وعنوان وعنوان فرعي، وعند الضغط ينقل لمسار [_HomeServiceItem.route].
class _ServiceCard extends StatelessWidget {
  final _HomeServiceItem item;
  const _ServiceCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.route == AppRoutes.services) {
          final homeState = context.findAncestorStateOfType<_HomeScreenState>();
          if (homeState != null) {
            homeState._goToTab(NavTab.services);
            return;
          }
        }
        Navigator.pushNamed(context, item.route);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.outline),
          boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: AppColors.primary, size: 22),
            ),
            const Spacer(),
            Text(item.title, style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
            const SizedBox(height: 2),
            Text(item.subtitle, style: GoogleFonts.urbanist(fontSize: 12, color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

/// كارد الحجز النشط — يظهر فقط عندما يوجد طلب غير مكتمل وغير ملغي.
/// يتابع حالة [OrdersCubit] ويعرض أول طلب نشط مع رابط للتفاصيل.
class _ActiveBookingCard extends StatelessWidget {
  final double topPadding;
  const _ActiveBookingCard({this.topPadding = 16});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state is! OrdersLoaded) return const SizedBox.shrink();
        final active = state.orders.where((o) => !o.isCompleted && !o.isCancelled).toList();
        if (active.isEmpty) return const SizedBox.shrink();
        final order = active.first;

        return Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(AppLocalizations.of(context)!.activeBooking,
                    style: GoogleFonts.urbanist(
                        fontSize: 18, fontWeight: FontWeight.w700,
                        color: AppColors.onSurface, letterSpacing: -0.2)),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.orderDetail, arguments: order),
                  child: Text(AppLocalizations.of(context)!.details,
                      style: GoogleFonts.urbanist(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ),
              ]),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.orderDetail, arguments: order),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.80),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 1.5,
                    ),
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.20), blurRadius: 16, offset: const Offset(0, 6))],
                  ),
                  child: Row(children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.build_circle_outlined, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(order.service?.title ?? 'Service',
                            style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(order.status.toUpperCase(),
                            style: GoogleFonts.urbanist(fontSize: 11, color: AppColors.neon, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white70, size: 22),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// بانر الترويج الموسمي في أسفل الصفحة.
/// يعرض صورة خلفية مع gradient وعنوان العرض وزر "Claim Now".
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 175,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppConstants.imgPromoCarBanner,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: AppColors.primary),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xF21D3C87), Color(0x991D3C87), Colors.transparent],
                  stops: [0.0, 0.55, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.limitedOffer,
                        style: GoogleFonts.urbanist(fontSize: 9, fontWeight: FontWeight.w700,
                            letterSpacing: 2.5, color: AppColors.neon)),
                    const SizedBox(height: 4),
                    Text(AppLocalizations.of(context)!.summerShinePackage,
                        style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white, height: 1.2)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.services),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
                        child: Text(AppLocalizations.of(context)!.claimNow,
                            style: GoogleFonts.urbanist(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: AppColors.primary)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// نموذج بيانات ثابت يصف خدمة واحدة في قائمة [_ServicesSection].
/// يحتوي على الأيقونة والعنوان والعنوان الفرعي ومسار التنقل.
class _HomeServiceItem {
  final IconData icon;
  final String title;
  final String subtitle;
  /// مسار التنقل (Route name) لشاشة الخدمة.
  final String route;
  const _HomeServiceItem({required this.icon, required this.title, required this.subtitle, required this.route});
}

// Deleted _HomeSearchBar since search functionality was removed from the home screen
