import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/utils/booking_navigation.dart';
import 'package:revexa/core/constants/app_constants.dart';
import 'package:revexa/shared/widgets/app_bar_avatar.dart';

class TiresDetailScreen extends StatelessWidget {
  const TiresDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _TiresAppBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BackToServices(),
                  _ImageGallery(),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ServiceInfoCard(),
                        const SizedBox(height: 16),
                        _PricingBookCard(),
                        const SizedBox(height: 20),
                        _AssistanceCard(),
                        const SizedBox(height: 28),
                        _WhatsIncludedSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TiresAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16,
        right: 16,
        bottom: 14,
      ),
      child: Row(
        children: [
          GestureDetector(
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
          const SizedBox(width: 12),
          Text(
            'REVEXA SERVICE',
            style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
          const Spacer(),
          const AppAppBarAvatar(),
        ],
      ),
    );
  }
}

class _BackToServices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant, size: 15),
            const SizedBox(width: 6),
            Text(
              'BACK TO SERVICES',
              style: GoogleFonts.urbanist(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant, letterSpacing: 1.0),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              AppConstants.imgTiresDetail1,
              width: double.infinity, height: 220, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 220,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF16213E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
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
                    AppConstants.imgTiresDetail2,
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
                    AppConstants.imgTiresDetail3,
                    height: 120, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(height: 120, color: AppColors.surface),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outline),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MAINTENANCE SERVICE',
            style: GoogleFonts.urbanist(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 1.5),
          ),
          const SizedBox(height: 8),
          Text(
            'Tires',
            style: GoogleFonts.urbanist(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.onSurface, letterSpacing: -0.8, height: 1.1),
          ),
          const SizedBox(height: 10),
          Text(
            'Ensure your safety and optimize your vehicle\'s performance with our comprehensive tire care suite. We provide expert handling for all luxury and performance vehicles.',
            style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.onSurfaceVariant, height: 1.65),
          ),
          const SizedBox(height: 18),
         const _InfoRow(icon: Icons.build_outlined, label: 'SERVICE SCOPE', value: 'Tire repair, rotation, & pressure check'),
          const SizedBox(height: 12),
          const _InfoRow(icon: Icons.schedule_outlined, label: 'ESTIMATED DURATION', value: '45 mins'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: AppColors.primary, size: 17),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.urbanist(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant, letterSpacing: 0.8)),
              const SizedBox(height: 2),
              Text(value, style: GoogleFonts.urbanist(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PricingBookCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Starting from', style: GoogleFonts.urbanist(fontSize: 12, color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 2),
                  Text(
                    '\$60.00',
                    style: GoogleFonts.urbanist(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.onSurface, letterSpacing: -0.8),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Availability', style: GoogleFonts.urbanist(fontSize: 10, color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 2),
                  Text('Next: Today, 2PM', style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF22C55E))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _IncludeCheck(label: 'Genuine Parts'),
          const SizedBox(height: 6),
          const _IncludeCheck(label: '1 Year Warranty'),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: () => openServiceBooking(context, id: 'tires', title: 'Tires', price: 60, description: 'Tire repair and change'),
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.30), blurRadius: 14, offset: const Offset(0, 5))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Book Now', style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IncludeCheck extends StatelessWidget {
  final String label;
  const _IncludeCheck({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle),
          child: const Icon(Icons.check, color: Colors.white, size: 12),
        ),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.urbanist(fontSize: 13, color: AppColors.onSurface, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _AssistanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.30), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Need assistance?', style: GoogleFonts.urbanist(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 2),
                Text('Talk to a specialist now', style: GoogleFonts.urbanist(fontSize: 12, color: Colors.white.withValues(alpha: 0.75))),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.phone_outlined, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

class _WhatsIncludedSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What's included in\nthis service?",
          style: GoogleFonts.urbanist(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.onSurface, letterSpacing: -0.4, height: 1.2),
        ),
        const SizedBox(height: 20),
        const _IncludedItem(
          icon: Icons.sync_rounded,
          title: 'Tire Rotation',
          subtitle: 'Systematic rotation of tires to ensure even tread wear across all four wheels, extending the lifespan of your set.',
        ),
        const SizedBox(height: 14),
        const _IncludedItem(
          icon: Icons.compress_rounded,
          title: 'Pressure Calibration',
          subtitle: 'Precision inflation to manufacturer specifications, optimizing fuel efficiency and handling dynamics.',
        ),
        const SizedBox(height: 14),
        const _IncludedItem(
          icon: Icons.search_rounded,
          title: 'Detailed Inspection',
          subtitle: 'Multi-point check for punctures, sidewall integrity, and suspension alignment indicators by certified techs.',
        ),
      ],
    );
  }
}

class _IncludedItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _IncludedItem({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
              const SizedBox(height: 4),
              Text(subtitle, style: GoogleFonts.urbanist(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.55)),
            ],
          ),
        ),
      ],
    );
  }
}
