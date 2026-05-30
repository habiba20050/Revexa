import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/constants/app_constants.dart';
import 'package:revexa/l10n/app_localizations.dart';

class UpdatesBody extends StatelessWidget {
  const UpdatesBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        // Top App Bar
        Container(
          color: AppColors.surface,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 12,
            left: 20,
            right: 20,
            bottom: 14,
          ),
          child: Row(
            children: [
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
                'Revexa',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainerHigh,
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.20), width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    AppConstants.imgUpdatesProfileAvatar,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(Icons.person_outline, color: AppColors.primary, size: 18),
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page header
                Text(
                  l10n.updates,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.updatesSubtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),

                // Recent section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.updatesRecent,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        l10n.updatesNew(2),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Vehicle health alert
                _NotificationCard(
                  iconBg: AppColors.errorContainer,
                  iconColor: AppColors.error,
                  icon: Icons.warning_amber_rounded,
                  title: l10n.updatesVehicleAlert,
                  time: 'Just now',
                  body:
                      'Tire pressure low on your Porsche 911. Recommendation: Visit the nearest station or request mobile assistance.',
                  hasAction: true,
                  actionLabel: l10n.updatesViewDiagnostic,
                ),
                const SizedBox(height: 12),

                // Booking confirmation
                _NotificationCard(
                  iconBg: AppColors.primary.withValues(alpha: 0.05),
                  iconColor: AppColors.primary,
                  icon: Icons.task_alt,
                  title: l10n.updatesBookingConfirmed,
                  time: '2h ago',
                  body:
                      'Mobile Wash confirmed for 2 PM today. Our specialist David is en route.',
                ),
                const SizedBox(height: 32),

                // Earlier section
                Text(
                  l10n.updatesEarlier,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),

                // Service reminder (tall card)
                _ServiceReminderCard(),
                const SizedBox(height: 12),

                // Platform news card
                _PlatformNewsCard(),
                const SizedBox(height: 12),

                // Service completed
                _NotificationCard(
                  iconBg: const Color(0xFFF1F5F9),
                  iconColor: const Color(0xFF64748B),
                  icon: Icons.history,
                  title: l10n.updatesServiceCompleted,
                  time: '3 days ago',
                  body:
                      'The brake pad replacement for your Mercedes S-Class has been completed.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String time;
  final String body;
  final bool hasAction;
  final String? actionLabel;

  const _NotificationCard({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.time,
    required this.body,
    this.hasAction = false,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      time,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.secondary,
                    height: 1.4,
                  ),
                ),
                if (hasAction) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        actionLabel ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward,
                          size: 12, color: AppColors.primary),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceReminderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.tertiaryFixed,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.calendar_month,
                color: AppColors.onTertiaryFixedVariant, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.updatesServiceReminder,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Oil change due for your BMW M5 within the next 200 miles.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.secondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFF8FAFC), height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.updatesYesterday,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.20),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  l10n.updatesSchedule,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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

class _PlatformNewsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section — real car interior image
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
            child: SizedBox(
              height: 64,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Real luxury interior image (opacity: 60% as in design)
                  Image.asset(
                    AppConstants.imgUpdatesCarInterior,
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(0.6),
                    errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1A2A60)),
                  ),
                  // Gradient overlay (from-transparent to-primary-container)
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xFF1D3C87)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.updatesPlatformNews,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Now offering premium interior detailing packages.',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFFE0E7FF),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.updatesFeatured,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                    color: const Color(0xFF93C5FD),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
