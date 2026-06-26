import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/utils/booking_navigation.dart';
import 'package:revexa/core/constants/app_constants.dart';

class OilServiceDetailScreen extends StatelessWidget {
  const OilServiceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _OilServiceAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _BackToServices(),
                  const SizedBox(height: 20),
                  _ServiceHeader(),
                  const SizedBox(height: 24),
                  const _FeatureCard(
                    icon: Icons.schedule_outlined,
                    title: 'Estimated Duration',
                    subtitle: 'Approximately 30 mins while you wait in our luxury lounge.',
                  ),
                  const SizedBox(height: 12),
                  const _FeatureCard(
                    icon: Icons.verified_outlined,
                    title: 'Premium Synthetic',
                    subtitle: 'High-grade synthetic blends for maximum engine life.',
                  ),
                  const SizedBox(height: 12),
                  const _FeatureCard(
                    icon: Icons.build_outlined,
                    title: 'Filter Replacement',
                    subtitle: 'Genuine or OEM-grade filter replacements included.',
                  ),
                  const SizedBox(height: 12),
                  const _FeatureCard(
                    icon: Icons.security_outlined,
                    title: 'Multi-point Check',
                    subtitle: 'Complimentary 21-point inspection included.',
                  ),
                  const SizedBox(height: 20),
                  _NextAvailableCard(),
                  const SizedBox(height: 20),
                  _PricingSection(),
                  const SizedBox(height: 24),
                  _ServiceComparisonTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OilServiceAppBar extends StatelessWidget {
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.10),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.20), width: 2),
            ),
            child: Icon(Icons.person_outline, color: AppColors.primary, size: 18),
          ),
        ],
      ),
    );
  }
}

class _BackToServices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant, size: 16),
          const SizedBox(width: 6),
          Text(
            'Back to Services',
            style: GoogleFonts.urbanist(fontSize: 13, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _ServiceHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.oil_barrel_outlined, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.outline),
              ),
              child: Text(
                'MAINTENANCE',
                style: GoogleFonts.urbanist(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant, letterSpacing: 1.2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Oil Service',
          style: GoogleFonts.urbanist(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.onSurface, letterSpacing: -0.8, height: 1.1),
        ),
        const SizedBox(height: 10),
        Text(
          'Keep your engine running at peak performance with our premium synthetic oil change and filter replacement. We use high-quality oils tailored to your vehicle\'s specifications.',
          style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.onSurfaceVariant, height: 1.65),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureCard({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(height: 12),
          Text(title, style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
          const SizedBox(height: 4),
          Text(subtitle, style: GoogleFonts.urbanist(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.5)),
        ],
      ),
    );
  }
}

class _NextAvailableCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 140,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppConstants.imgOilServiceDetail,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1D3C87), Color(0xFF2A4FA0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withValues(alpha: 0.5), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Next Available: Today, 2:30 PM',
                      style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
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

class _PricingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Starting from',
                  style: GoogleFonts.urbanist(fontSize: 12, color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 2),
                Text(
                  '\$75.00',
                  style: GoogleFonts.urbanist(fontSize: 34, fontWeight: FontWeight.w800, color: AppColors.onSurface, letterSpacing: -1.0),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                'Full synthetic blend',
                style: GoogleFonts.urbanist(fontSize: 12, color: AppColors.onSurfaceVariant),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
   const     _IncludeItem(label: 'Full Synthetic Oil (up to 5 qtrs)'),
        const SizedBox(height: 8),
        const _IncludeItem(label: 'Premium Oil Filter'),
        const SizedBox(height: 8),
        const _IncludeItem(label: 'Fluid Top-off'),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => openServiceBooking(context, id: 'oil-service', title: 'Oil Service', price: 75, description: 'Synthetic oil change'),
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
              const    Icon(Icons.calendar_today_outlined, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text('Book Now', style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            'No credit card required to reserve.',
            style: GoogleFonts.urbanist(fontSize: 11, color: AppColors.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

class _IncludeItem extends StatelessWidget {
  final String label;
  const _IncludeItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 13),
        ),
        const SizedBox(width: 10),
        Text(label, style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.onSurface, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _ServiceComparisonTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Comparison',
          style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.onSurface, letterSpacing: -0.3),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outline),
          ),
          child: Column(
            children: [
              _TableHeader(),
              Divider(color: AppColors.outline, height: 1),
             const _TableRow(
                feature: 'Oil Type',
                standard: 'Conventional',
                synth: 'Full Synth',
                isEven: false,
              ),
              Divider(color: AppColors.outline, height: 1),
             const _TableRow(
                feature: 'Mileage Interval',
                standard: '3,000 Miles',
                synth: '7,500–10,000 Miles',
                isEven: true,
              ),
              Divider(color: AppColors.outline, height: 1),
              const _TableRow(
                feature: 'Engine Protection',
                standard: 'Basic',
                synth: 'Maxim / High Temp',
                isEven: false,
              ),
              Divider(color: AppColors.outline, height: 1),
              const _TableRow(
                feature: 'Multi-point Inspection',
                standard: '✓',
                synth: '✓',
                isEven: true,
                isCentered: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('Features', style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
          ),
          Expanded(
            flex: 2,
            child: Text('Standard', style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant), textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Synth (This Service)',
                style: GoogleFonts.urbanist(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  final String feature;
  final String standard;
  final String synth;
  final bool isEven;
  final bool isCentered;

  const _TableRow({
    required this.feature,
    required this.standard,
    required this.synth,
    required this.isEven,
    this.isCentered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: isEven ? AppColors.surfaceContainerLow.withValues(alpha: 0.5) : Colors.transparent,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(feature, style: GoogleFonts.urbanist(fontSize: 13, color: AppColors.onSurface, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              standard,
              style: GoogleFonts.urbanist(fontSize: 12, color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              synth,
              style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
