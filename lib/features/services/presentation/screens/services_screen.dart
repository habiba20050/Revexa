import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/constants/app_routes.dart';
import 'package:revexa/core/constants/app_constants.dart';
import 'package:revexa/features/services/data/models/service_model.dart';
import 'package:revexa/features/services/presentation/cubit/services_cubit.dart';
import 'package:revexa/features/services/presentation/cubit/services_state.dart';
import 'package:revexa/core/utils/booking_navigation.dart';
import 'package:revexa/shared/widgets/shimmer_widgets.dart';

class ServicesScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;
  final VoidCallback? onOpenSettings;

  const ServicesScreen({super.key, this.onBackToHome, this.onOpenSettings});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServicesCubit>().loadServices(limit: 20);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _ServicesAppBar(onBackToHome: widget.onBackToHome),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Precision Care',
                          style: GoogleFonts.inter(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                            letterSpacing: -0.8,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Select from our range of executive automotive\nservices brought directly to you.',
                          style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurfaceVariant, height: 1.5),
                        ),
                        const SizedBox(height: 20),
                        _SearchBar(
                          controller: _searchCtrl,
                          onChanged: (v) => setState(() => _query = v.toLowerCase()),
                        ),
                        const SizedBox(height: 16),
                        const _NearbyWorkshopsEntry(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  BlocBuilder<ServicesCubit, ServicesState>(
                    builder: (context, state) {
                      if (state is ServicesLoading || state is ServicesInitial) {
                        return _buildSkeletons();
                      }
                      if (state is ServicesError) {
                        return _ServicesContent(
                          services: const [],
                          useStaticFallback: true,
                          onOpenSettings: widget.onOpenSettings,
                        );
                      }
                      if (state is ServicesLoaded) {
                        final services = state.servicesPage.services
                            .where((s) => _query.isEmpty ||
                                s.title.toLowerCase().contains(_query) ||
                                s.description.toLowerCase().contains(_query))
                            .toList();

                        if (services.isEmpty) {
                          return _ServicesContent(
                            services: const [],
                            useStaticFallback: true,
                            onOpenSettings: widget.onOpenSettings,
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () => context.read<ServicesCubit>().loadServices(limit: 20),
                          child: _ServicesContent(
                            services: services,
                            onOpenSettings: widget.onOpenSettings,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        children: [
          const ShimmerBox(width: double.infinity, height: 180, radius: 20),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.88,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(4, (_) => const ServiceCardSkeleton()),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(msg, textAlign: TextAlign.center, style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 14)),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => context.read<ServicesCubit>().loadServices(limit: 20),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: AppColors.onSurfaceVariant),
            const SizedBox(height: 12),
            Text('No services found', style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _NearbyWorkshopsEntry extends StatelessWidget {
  const _NearbyWorkshopsEntry();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AppRoutes.nearbyWorkshops),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.map_rounded, color: AppColors.primary, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nearby Workshops',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Find repair shops and service centers on the map',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServicesAppBar extends StatelessWidget {
  final VoidCallback? onBackToHome;

  const _ServicesAppBar({this.onBackToHome});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 12,
        right: 20,
        bottom: 14,
      ),
      child: Row(
        children: [
          if (onBackToHome != null)
            IconButton(
              onPressed: onBackToHome,
              icon: const Icon(Icons.arrow_back_rounded),
              color: AppColors.onSurface,
              tooltip: 'Back to Home',
            ),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Text(
            'REVEXA',
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 0.5),
          ),
          const Spacer(),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainerHigh,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.20), width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                AppConstants.imgProfileAvatar,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(Icons.person_outline, color: AppColors.primary, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurface),
        decoration: InputDecoration(
          hintText: 'Search for a service...',
          hintStyle: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: AppColors.onSurfaceVariant, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}

class _ServicesContent extends StatelessWidget {
  final List<Service> services;
  final bool useStaticFallback;
  final VoidCallback? onOpenSettings;

  const _ServicesContent({
    required this.services,
    this.useStaticFallback = false,
    this.onOpenSettings,
  });

  static const _staticServices = [
    _StaticService(
      id: 'mobile-wash',
      icon: Icons.local_car_wash_rounded,
      title: 'Mobile Wash',
      subtitle: 'Full exterior foam wash and\ninterior detailing at your door.',
      priceValue: 45,
      price: 'From \$45.00',
      route: AppRoutes.mobileWashDetail,
      isFeatured: true,
    ),
    _StaticService(
      id: 'maintenance',
      icon: Icons.build_rounded,
      title: 'Maintenance',
      subtitle: 'Engine Check',
      priceValue: 89,
      price: '\$89.00',
      route: AppRoutes.maintenanceDetail,
      isFeatured: false,
    ),
    _StaticService(
      id: 'tires',
      icon: Icons.tire_repair,
      title: 'Tires',
      subtitle: 'Repair & Change',
      priceValue: 60,
      price: '\$60.00',
      route: AppRoutes.tiresDetail,
      isFeatured: false,
    ),
    _StaticService(
      id: 'oil-service',
      icon: Icons.oil_barrel_outlined,
      title: 'Oil Service',
      subtitle: 'Synthetic Fluid',
      priceValue: 75,
      price: '\$75.00',
      route: AppRoutes.oilServiceDetail,
      isFeatured: false,
    ),
    _StaticService(
      id: 'battery',
      icon: Icons.battery_charging_full_outlined,
      title: 'Battery',
      subtitle: 'Health Check',
      priceValue: 40,
      price: '\$40.00',
      route: AppRoutes.batteryDetail,
      isFeatured: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final fromApi = services.isNotEmpty && !useStaticFallback;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (fromApi) ...[
            Text('Available Services', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
            const SizedBox(height: 14),
            if (services.isNotEmpty) ...[
              _ApiFeaturedCard(service: services.first),
              const SizedBox(height: 12),
            ],
            if (services.length > 1)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length - 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) => _ServiceCard(service: services[index + 1]),
              ),
          ] else ...[
            _FeaturedCard(service: _staticServices[0]),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.92,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: _staticServices.skip(1).map((s) => _GridCard(service: s)).toList(),
            ),
            const SizedBox(height: 16),
            _EliteServiceBanner(),
            const SizedBox(height: 16),
            _ConciergeCard(onOpenSettings: onOpenSettings),
          ],
        ],
      ),
    );
  }
}

class _StaticService {
  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final double priceValue;
  final String price;
  final String route;
  final bool isFeatured;
  const _StaticService({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.priceValue,
    required this.price,
    required this.route,
    required this.isFeatured,
  });
}

class _ServiceCard extends StatelessWidget {
  final Service service;
  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.serviceDetail, arguments: service),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outline),
          boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: service.firstImageUrl.isNotEmpty
                    ? Image.network(service.firstImageUrl, fit: BoxFit.cover, width: double.infinity, errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHigh))
                    : Image.asset(AppConstants.imgServices1, fit: BoxFit.cover, width: double.infinity),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                  const SizedBox(height: 4),
                  Text(service.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.4)),
                  const SizedBox(height: 10),
                  Text('\$${service.price.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final _StaticService service;
  const _FeaturedCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, service.route),
      child: Container(
        constraints: const BoxConstraints(minHeight: 200),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outline),
          boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 3))],
        ),
        child: IntrinsicHeight(
          child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(service.icon, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(service.title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.onSurface, letterSpacing: -0.3)),
                    const SizedBox(height: 4),
                    Text(service.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.35)),
                    const SizedBox(height: 10),
                    Text(service.price, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => openServiceBooking(
                        context,
                        id: service.id,
                        title: service.title,
                        price: service.priceValue.toDouble(),
                        description: service.subtitle,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('Book Now', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
              child: SizedBox(
                width: 130,
                height: double.infinity,
                child: Image.asset(
                  AppConstants.imgServices1,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.surfaceContainerHigh,
                    child: Icon(service.icon, size: 40, color: AppColors.onSurfaceVariant.withValues(alpha: 0.3)),
                  ),
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _ApiFeaturedCard extends StatelessWidget {
  final Service service;
  const _ApiFeaturedCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openServiceBooking(
        context,
        id: service.id,
        title: service.title,
        price: service.price,
        description: service.description,
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 200),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outline),
          boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 3))],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(service.title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
                      const SizedBox(height: 6),
                      Text(
                        service.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.35),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'From \$${service.price.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('Book Now', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
              if (service.firstImageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
                  child: SizedBox(
                    width: 120,
                    child: Image.network(
                      service.firstImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridCard extends StatelessWidget {
  final _StaticService service;
  const _GridCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, service.route),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outline),
          boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(service.icon, color: AppColors.primary, size: 22),
            ),
            const Spacer(),
            Text(service.title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
            const SizedBox(height: 2),
            Text(service.subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 6),
            Text(service.price, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}

class _EliteServiceBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 140,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppConstants.imgServices2,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1D3C87), Color(0xFF2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xF01D3C87), Color(0x881D3C87), Colors.transparent],
                  stops: [0.0, 0.5, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ELITE SERVICE',
                    style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: const Color(0xFF06B6D4), letterSpacing: 2.0),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Signature\nDetailing',
                    style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, height: 1.2, letterSpacing: -0.3),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text('\$249.00', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                      const SizedBox(width: 8),
                      Text('\$320.00', style: GoogleFonts.inter(fontSize: 12, color: Colors.white54, decoration: TextDecoration.lineThrough)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => openServiceBooking(
                      context,
                      id: 'signature-detailing',
                      title: 'Signature Detailing',
                      price: 249,
                      description: 'Elite service package',
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'BOOK PACKAGE',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 1.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConciergeCard extends StatelessWidget {
  final VoidCallback? onOpenSettings;

  const _ConciergeCard({this.onOpenSettings});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          Text(
            'Custom Fleet Care?',
            style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.onSurface),
          ),
          const SizedBox(height: 6),
          Text(
            'Our concierge team is available 24/7 for\ncustom maintenance plans.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.5),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ConciergeBtn(
                  label: 'Contact Us',
                  primary: false,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ConciergeBtn(
                  label: 'View / FAQ',
                  primary: false,
                  onTap: onOpenSettings ?? () => Navigator.pushNamed(context, AppRoutes.settings),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConciergeBtn extends StatelessWidget {
  final String label;
  final bool primary;
  final VoidCallback onTap;
  const _ConciergeBtn({required this.label, required this.primary, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: primary ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primary ? AppColors.primary : AppColors.outline),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: primary ? Colors.white : AppColors.onSurface),
          ),
        ),
      ),
    );
  }
}
