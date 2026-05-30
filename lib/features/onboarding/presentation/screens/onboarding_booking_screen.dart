import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/constants/app_routes.dart';
import 'package:revexa/core/constants/app_constants.dart';
import 'package:revexa/shared/widgets/primary_button.dart';

class OnboardingBookingScreen extends StatelessWidget {
  const OnboardingBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.directions_car, color: AppColors.primary, size: 22),
                      const SizedBox(width: 6),
                      Text(
                        'REVEXA',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.0,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.signIn),
                    child: Text(
                      'Skip',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Hero image card with floating accessory images
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.05),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(color: AppColors.outline.withValues(alpha: 0.5)),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Gradient background tint
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.primary.withValues(alpha: 0.05),
                                        AppColors.neon.withValues(alpha: 0.05),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Center content (service chips)
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(alpha: 0.3),
                                          blurRadius: 32,
                                          spreadRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                      size: 44,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  const Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      _ServiceChip(icon: Icons.local_car_wash, label: 'Mobile Wash'),
                                      _ServiceChip(icon: Icons.build, label: 'Maintenance'),
                                      _ServiceChip(icon: Icons.ev_station, label: 'Charging'),
                                      _ServiceChip(icon: Icons.handyman, label: 'Repairs'),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Floating top-right: luxury car dashboard image
                            Positioned(
                              top: 16,
                              right: -8,
                              child: Transform.rotate(
                                angle: 0.10,
                                child: Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.white, width: 4),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x33000000),
                                        blurRadius: 16,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      AppConstants.imgOnboardingCarDashboard,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHigh),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Floating bottom-left: mechanic image (circle)
                            Positioned(
                              bottom: 24,
                              left: -16,
                              child: Transform.rotate(
                                angle: -0.21,
                                child: Container(
                                  width: 88,
                                  height: 88,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 4),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x33000000),
                                        blurRadius: 16,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      AppConstants.imgOnboardingMechanic,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHigh),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                    Text(
                      'Book services on-demand.',
                      style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                        height: 1.2,
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Schedule maintenance, washes, and emergency services right from your phone.',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: AppColors.onSurfaceVariant,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Pagination dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 32, height: 10, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(5))),
                        const SizedBox(width: 10),
                        Container(width: 10, height: 10, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(5))),
                        const SizedBox(width: 10),
                        Container(width: 10, height: 10, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(5))),
                      ],
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      label: 'Next',
                      onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.onboardingTracking),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
        child: Text.rich(
          TextSpan(
            text: 'Already have an account? ',
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w500),
            children: [
              WidgetSpan(
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.signIn),
                  child: Text('Sign In', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ServiceChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ServiceChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
        ],
      ),
    );
  }
}
