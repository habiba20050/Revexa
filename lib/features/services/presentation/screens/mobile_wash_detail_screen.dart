import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/constants/app_routes.dart';
import 'package:revexa/core/utils/booking_navigation.dart';
import 'package:revexa/core/constants/app_constants.dart';

class MobileWashDetailScreen extends StatelessWidget {
  const MobileWashDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _MobileWashAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ImageGallery(),
                      const SizedBox(height: 24),
                      _DescriptionSection(),
                      const SizedBox(height: 24),
                      _FeaturesSection(),
                      const SizedBox(height: 24),
                      _WorkflowSection(),
                      const SizedBox(height: 24),
                      _PricingCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BookNowBar(),
          ),
        ],
      ),
    );
  }
}

class _MobileWashAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(Icons.arrow_back, color: AppColors.onSurface, size: 20),
          ),
        ),
      ),
      title: Text(
        'REVEXA SERVICE',
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.10),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.20), width: 2),
            ),
            child: Icon(Icons.person_outline, color: AppColors.primary, size: 18),
          ),
        ),
      ],
    );
  }
}

class _ImageGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
              ),
              child: Text(
                'PREMIUM DETAIL',
                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 1.0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Mobile Wash',
          style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.onSurface, letterSpacing: -0.5),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timer_outlined, color: AppColors.primary, size: 16),
              const SizedBox(width: 6),
              Text('Estimated 60 mins', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.onSurface)),
            ],
          ),
        ),
        const SizedBox(height: 16),

        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            AppConstants.imgMobileWashDetail1,
            width: double.infinity, height: 200, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 200, color: AppColors.surfaceContainerHigh,
              child: Icon(Icons.local_car_wash_rounded, size: 56, color: AppColors.onSurfaceVariant.withValues(alpha: 0.3)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  AppConstants.imgMobileWashDetail2,
                  height: 120, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(height: 120, color: AppColors.surfaceContainerHigh),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  AppConstants.imgMobileWashDetail3,
                  height: 120, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(height: 120, color: AppColors.surfaceContainerHigh),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.onSurface, letterSpacing: -0.2)),
        const SizedBox(height: 10),
        Text(
          'Full exterior foam wash and interior detailing at your door. We bring the luxury showroom finish to your driveway. Our eco-friendly foam technology safely lifts dirt, while our meticulous interior process ensures every corner is sanitized and refreshed.',
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurfaceVariant, height: 1.65),
        ),
      ],
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FeatureItem(
          icon: Icons.local_car_wash_rounded,
          title: 'Foam Cannon Wash',
          subtitle: 'Thick foam lifts dirt and abrasives for scratch-free brilliance.',
        ),
        _FeatureItem(
          icon: Icons.cleaning_services_rounded,
          title: 'Deep Interior Clean',
          subtitle: 'Thorough vacuuming, interior cleaning, and sanitizing.',
        ),
        _FeatureItem(
          icon: Icons.location_on_outlined,
          title: 'At Your Location',
          subtitle: 'Fully equipped mobile van arrives at your home or office.',
        ),
        _FeatureItem(
          icon: Icons.star_outline_rounded,
          title: 'Pro Results',
          subtitle: 'Experienced detailers using premium grade products.',
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureItem({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                const SizedBox(height: 3),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkflowSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Service Workflow', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.onSurface, letterSpacing: -0.2)),
        const SizedBox(height: 16),
        _WorkflowStep(
          number: '01',
          title: 'Pre-Wash Assessment',
          subtitle: 'Inspect overall paint condition and target areas.',
        ),
        _WorkflowStep(
          number: '02',
          title: 'Snow Foam Treatment',
          subtitle: 'Thick dwell foam to encapsulate and lift road grime safely.',
        ),
        _WorkflowStep(
          number: '03',
          title: 'Interior Detailing',
          subtitle: 'Compressed air blowout and upholstery rejuvenation.',
          isLast: true,
        ),
      ],
    );
  }
}

class _WorkflowStep extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final bool isLast;

  const _WorkflowStep({
    required this.number,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  number,
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                const SizedBox(height: 3),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.5)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PricingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('STARTING FROM', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant, letterSpacing: 1.2)),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('\$45.00', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.onSurface, letterSpacing: -0.5)),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('/ vehicle', style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant)),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.local_car_wash_rounded, color: AppColors.primary, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.outline),
          const SizedBox(height: 12),
          _PricingRow(label: 'Duration', value: '60 mins'),
          const SizedBox(height: 8),
          _PricingRow(label: 'Mobility', value: 'We come to you'),
          const SizedBox(height: 8),
          _PricingRow(label: 'Availability', value: 'Daily 8AM–8PM', valueColor: const Color(0xFF22C55E)),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => openServiceBooking(context, id: 'mobile-wash', title: 'Mobile Wash', price: 45, description: 'Mobile car wash'),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.30), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text('BOOK NOW', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1.0)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Terms without service fee may apply at checkout. Final price confirmed with 24h before appointment.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 10, color: AppColors.onSurfaceVariant, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _PricingRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _PricingRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.onSurfaceVariant)),
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: valueColor ?? AppColors.onSurface),
        ),
      ],
    );
  }
}

class _BookNowBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 20, offset: Offset(0, -4))],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Starting from', style: GoogleFonts.inter(fontSize: 11, color: AppColors.onSurfaceVariant)),
              Text('\$45', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => openServiceBooking(context, id: 'mobile-wash', title: 'Mobile Wash', price: 45, description: 'Mobile car wash'),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.30), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_outlined, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text('Book Now', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
