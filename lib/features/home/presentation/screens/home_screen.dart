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
import 'package:revexa/shared/widgets/app_logo.dart';
import 'package:revexa/shared/widgets/app_bottom_nav_bar.dart';
import 'package:revexa/features/bookings/presentation/screens/bookings_screen.dart';
import 'package:revexa/features/updates/presentation/screens/updates_screen.dart';
import 'package:revexa/features/services/presentation/screens/services_screen.dart';
import 'package:revexa/features/profile/presentation/screens/profile_screen.dart';
import 'package:revexa/features/settings/presentation/screens/settings_screen.dart';
import 'package:revexa/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NavTab _activeTab = NavTab.home;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsCubit>().loadProducts();
      context.read<OrdersCubit>().loadOrders();
    });
  }

  Widget _buildBody() {
    switch (_activeTab) {
      case NavTab.home:
        return const _HomeBody();
      case NavTab.services:
        return const ServicesScreen();
      case NavTab.bookings:
        return const BookingsBody();
      case NavTab.updates:
        return const UpdatesBody();
      case NavTab.profile:
        return const ProfileScreen();
      case NavTab.settings:
        return const Scaffold(body: SettingsBody());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.signIn);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: KeyedSubtree(
            key: ValueKey(_activeTab),
            child: _buildBody(),
          ),
        ),
        bottomNavigationBar: AppBottomNavBar(
          activeTab: _activeTab,
          onTabChanged: (tab) => setState(() => _activeTab = tab),
        ),
      ),
    );
  }
}

// ─── Home Body ────────────────────────────────────────────────────────────────

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HomeAppBar(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<ProductsCubit>().loadProducts();
              context.read<OrdersCubit>().loadOrders();
            },
            child: const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                children: [
                  _GreetingBanner(),
                  SizedBox(height: 20),
                  _VehicleHealthCard(),
                  SizedBox(height: 28),
                  _QuickActionsRow(),
                  SizedBox(height: 28),
                  _ServicesSection(),
                  SizedBox(height: 28),
                  _ActiveBookingCard(),
                  SizedBox(height: 28),
                  _PromoBanner(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        return Container(
          color: AppColors.surface,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 12,
            left: 24, right: 24, bottom: 12,
          ),
          child: Row(
            children: [
              const AppLogoMini(),
              const SizedBox(width: 12),
              Text('Revexa',
                  style: GoogleFonts.inter(
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
                  child: Stack(alignment: Alignment.center, children: [
                    Icon(Icons.notifications_outlined,
                        color: AppColors.onSurface, size: 22),
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(
                              color: AppColors.error, shape: BoxShape.circle)),
                    ),
                  ]),
                ),
              ),
              // Avatar
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.10),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.20), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      user?.firstName.isNotEmpty == true
                          ? user!.firstName[0].toUpperCase()
                          : 'U',
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w700,
                          color: AppColors.primary),
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
                    style: GoogleFonts.inter(fontSize: 13, color: AppColors.onSurfaceVariant),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('$name 👋',
                    style: GoogleFonts.inter(
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
                    style: GoogleFonts.inter(
                        fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ]),
            ),
          ],
        );
      },
    );
  }
}

class _VehicleHealthCard extends StatelessWidget {
  const _VehicleHealthCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 32, offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -48, right: -48,
            child: Container(
              width: 160, height: 160,
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06), shape: BoxShape.circle),
            ),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                'PREMIUM STATUS',
                style: GoogleFonts.inter(
                    fontSize: 10, fontWeight: FontWeight.w700,
                    letterSpacing: 2.0, color: Colors.white.withValues(alpha: 0.60)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text('OPTIMAL',
                    style: GoogleFonts.inter(
                        fontSize: 10, fontWeight: FontWeight.w700,
                        letterSpacing: 0.8, color: Colors.white)),
              ),
            ]),
            const SizedBox(height: 6),
            Text(
              'Vehicle Health',
              style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.3),
            ),
            const SizedBox(height: 20),
            Row(children: [
              SizedBox(
                width: 88, height: 88,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 88, height: 88,
                      child: CircularProgressIndicator(
                        value: 0.85,
                        strokeWidth: 7,
                        backgroundColor: Colors.white.withValues(alpha: 0.10),
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.neon),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(text: '85',
                            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                        TextSpan(text: '%',
                            style: GoogleFonts.inter(fontSize: 10, color: AppColors.neon)),
                      ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(children: [
                  _StatBar(label: 'Engine Power', value: 0.92, valueStr: '92%', color: AppColors.neon),
                  const SizedBox(height: 16),
                  _StatBar(label: 'Battery Life', value: 0.78, valueStr: '78%', color: Colors.white.withValues(alpha: 0.80)),
                ]),
              ),
            ]),
          ]),
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final double value;
  final String valueStr;
  final Color color;
  const _StatBar({required this.label, required this.value, required this.valueStr, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(
          child: Text(label, style: GoogleFonts.inter(fontSize: 10, color: Colors.white.withValues(alpha: 0.70)), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(width: 4),
        Text(valueStr, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
      ]),
      const SizedBox(height: 4),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.white.withValues(alpha: 0.10),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 5,
        ),
      ),
    ]);
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        _QuickAction(icon: Icons.local_car_wash_rounded, label: l10n.quickWash,
            onTap: () => Navigator.pushNamed(context, AppRoutes.mobileWashDetail)),
        const SizedBox(width: 12),
        _QuickAction(icon: Icons.build_rounded, label: l10n.quickService,
            onTap: () => Navigator.pushNamed(context, AppRoutes.maintenanceDetail)),
        const SizedBox(width: 12),
        _QuickAction(icon: Icons.tire_repair, label: l10n.quickTires,
            onTap: () => Navigator.pushNamed(context, AppRoutes.tiresDetail)),
        const SizedBox(width: 12),
        _QuickAction(icon: Icons.more_horiz_rounded, label: l10n.quickMore,
            onTap: () => Navigator.pushNamed(context, AppRoutes.services)),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outline),
          ),
          child: Column(children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(height: 6),
            Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurface), maxLines: 1, overflow: TextOverflow.ellipsis),
          ]),
        ),
      ),
    );
  }
}

class _ServicesSection extends StatelessWidget {
  const _ServicesSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Our Services',
                  style: GoogleFonts.inter(
                      fontSize: 18, fontWeight: FontWeight.w700,
                      color: AppColors.onSurface, letterSpacing: -0.2)),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.services),
                child: Text('Explore all',
                    style: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ),
            ]),
            const SizedBox(height: 16),
            if (state is ProductsLoading)
              _skeletonRow()
            else if (state is ProductsLoaded)
              _buildServiceCards(context, state)
            else if (state is ProductsError)
              Text(state.message,
                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.error)),
          ],
        );
      },
    );
  }

  Widget _skeletonRow() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(4, (_) => Container(
        decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(18)),
      )),
    );
  }

  Widget _buildServiceCards(BuildContext context, ProductsLoaded state) {
    final products = state.page.products.take(3).toList();
    if (products.isEmpty) {
      return Text(AppLocalizations.of(context)!.noServicesAvailable,
          style: GoogleFonts.inter(color: AppColors.onSurfaceVariant));
    }

    final staticServices = [
      _HomeServiceItem(icon: Icons.local_car_wash_rounded, title: 'Mobile Wash', subtitle: 'Coming to you', route: AppRoutes.mobileWashDetail),
      _HomeServiceItem(icon: Icons.build_rounded, title: 'Maintenance', subtitle: 'Expert care', route: AppRoutes.maintenanceDetail),
      _HomeServiceItem(icon: Icons.local_gas_station_outlined, title: 'Energy', subtitle: 'Fuel & Charge', route: AppRoutes.services),
      _HomeServiceItem(icon: Icons.settings_outlined, title: 'Parts', subtitle: 'Genuine kits', route: AppRoutes.services),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: staticServices.map((s) => GestureDetector(
        onTap: () => Navigator.pushNamed(context, s.route),
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
                child: Icon(s.icon, color: AppColors.primary, size: 22),
              ),
              const Spacer(),
              Text(s.title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
              const SizedBox(height: 2),
              Text(s.subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant)),
            ],
          ),
        ),
      )).toList(),
    );
  }
}

class _ActiveBookingCard extends StatelessWidget {
  const _ActiveBookingCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state is! OrdersLoaded) return const SizedBox.shrink();
        final active = state.orders.where((o) => !o.isCompleted && !o.isCancelled).toList();
        if (active.isEmpty) return const SizedBox.shrink();
        final order = active.first;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(AppLocalizations.of(context)!.activeBooking,
                  style: GoogleFonts.inter(
                      fontSize: 18, fontWeight: FontWeight.w700,
                      color: AppColors.onSurface, letterSpacing: -0.2)),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.orderDetail, arguments: order),
                child: Text(AppLocalizations.of(context)!.details,
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ),
            ]),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.orderDetail, arguments: order),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 6))],
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
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(order.status.toUpperCase(),
                          style: GoogleFonts.inter(fontSize: 11, color: AppColors.neon, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white70, size: 22),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 160,
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
                        style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700,
                            letterSpacing: 2.5, color: AppColors.neon)),
                    const SizedBox(height: 4),
                    Text(AppLocalizations.of(context)!.summerShinePackage,
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white, height: 1.2)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.services),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
                        child: Text(AppLocalizations.of(context)!.claimNow,
                            style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: AppColors.primary)),
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

class _HomeServiceItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  const _HomeServiceItem({required this.icon, required this.title, required this.subtitle, required this.route});
}
