import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/utils/booking_navigation.dart';

class BatteryDetailScreen extends StatelessWidget {
  const BatteryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _BatteryAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant, size: 15),
                        const SizedBox(width: 6),
                        Text('BACK TO SERVICES', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant, letterSpacing: 1.0)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1D3C87), Color(0xFF2563EB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -40, right: -40,
                            child: Container(width: 160, height: 160,
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), shape: BoxShape.circle)),
                          ),
                          Center(
                            child: Icon(Icons.battery_charging_full_rounded, size: 80, color: Colors.white.withValues(alpha: 0.25)),
                          ),
                          Positioned(
                            bottom: 16, left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                              child: Text('BATTERY SERVICE', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('MAINTENANCE SERVICE', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 1.5)),
                        const SizedBox(height: 8),
                        Text('Battery', style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.onSurface, letterSpacing: -0.8, height: 1.1)),
                        const SizedBox(height: 10),
                        Text(
                          'Complete battery health diagnostics and replacement service. We test, calibrate, and replace batteries for all vehicle makes using OEM-grade components.',
                          style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurfaceVariant, height: 1.65),
                        ),
                        const SizedBox(height: 18),
                      const  _InfoRow(icon: Icons.battery_charging_full_outlined, label: 'SERVICE SCOPE', value: 'Health check, test & replacement'),
                        const SizedBox(height: 12),
                   const     _InfoRow(icon: Icons.schedule_outlined, label: 'ESTIMATED DURATION', value: '30 mins'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
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
                                Text('Starting from', style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant)),
                                const SizedBox(height: 2),
                                Text('\$40.00', style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.onSurface, letterSpacing: -0.8)),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Availability', style: GoogleFonts.inter(fontSize: 10, color: AppColors.onSurfaceVariant)),
                                const SizedBox(height: 2),
                                Text('Same Day', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF22C55E))),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const _IncludeCheck(label: 'OEM-Grade Battery'),
                        const SizedBox(height: 6),
                        const _IncludeCheck(label: '2 Year Warranty'),
                        const SizedBox(height: 6),
                        const _IncludeCheck(label: 'Free Health Report'),
                        const SizedBox(height: 18),
                        GestureDetector(
                          onTap: () => openServiceBooking(context, id: 'battery', title: 'Battery', price: 40, description: 'Battery health check'),
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
                                Text('Book Now', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                        ),
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

class _BatteryAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12, left: 16, right: 16, bottom: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(9)),
              child: Icon(Icons.arrow_back, color: AppColors.onSurface, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Text('REVEXA SERVICE', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary)),
          const Spacer(),
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withValues(alpha: 0.10), border: Border.all(color: AppColors.primary.withValues(alpha: 0.20), width: 2)),
            child: Icon(Icons.person_outline, color: AppColors.primary, size: 18),
          ),
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
          width: 34, height: 34,
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(9)),
          child: Icon(icon, color: AppColors.primary, size: 17),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant, letterSpacing: 0.8)),
              const SizedBox(height: 2),
              Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
            ],
          ),
        ),
      ],
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
          width: 20, height: 20,
          decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle),
          child: const Icon(Icons.check, color: Colors.white, size: 12),
        ),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.onSurface, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
