import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/constants/app_routes.dart';
import 'package:revexa/core/constants/app_constants.dart';
import 'package:revexa/shared/widgets/primary_button.dart';

class OnboardingTrackingScreen extends StatelessWidget {
  const OnboardingTrackingScreen({super.key});

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
                      Text('REVEXA', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 2.0, color: AppColors.primary)),
                    ],
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.signIn),
                    child: Text('Skip', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)),
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
                    // Hero card — map image + floating technician card
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.05), blurRadius: 24, offset: const Offset(0, 8))],
                          border: Border.all(color: AppColors.surface),
                        ),
                        child: Stack(
                          children: [
                            // Map background image (full fill)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.asset(
                                  AppConstants.imgOnboardingMap,
                                  fit: BoxFit.cover,
                                  opacity: const AlwaysStoppedAnimation(0.8),
                                  errorBuilder: (_, __, ___) => Container(
                                    color: const Color(0xFFD4E5F0),
                                  ),
                                ),
                              ),
                            ),

                            // Location pin overlay (top-right)
                            Positioned(
                              top: 20,
                              right: 20,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                                ),
                                child: const Icon(Icons.location_on, color: Colors.white, size: 22),
                              ),
                            ),

                            // Floating technician card (bottom)
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.95),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFF1F5F9)),
                                  boxShadow: const [BoxShadow(color: Color(0x28000000), blurRadius: 24, offset: Offset(0, 8))],
                                ),
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        // Technician avatar — real image
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundImage: NetworkImage(AppConstants.imgTechnicianAvatar),
                                          backgroundColor: AppColors.surfaceContainerHigh,
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            width: 14,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF22C55E),
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.white, width: 2),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Marcus Chen', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                                              Row(
                                                children: [
                                                  Icon(Icons.star, size: 13, color: AppColors.primary),
                                                  const SizedBox(width: 2),
                                                  Text('4.9', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text('En route • Arriving in 8 mins', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                    Text(
                      'Track your technician in real-time.',
                      style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.onSurface, height: 1.2, letterSpacing: -0.3),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Watch as help arrives at your doorstep with our precise live tracking system.',
                      style: GoogleFonts.inter(fontSize: 15, color: AppColors.onSurfaceVariant, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Pagination dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 10, height: 10, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(5))),
                        const SizedBox(width: 10),
                        Container(width: 32, height: 10, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(5))),
                        const SizedBox(width: 10),
                        Container(width: 10, height: 10, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(5))),
                      ],
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      label: 'Next',
                      onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.onboardingFinal),
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
