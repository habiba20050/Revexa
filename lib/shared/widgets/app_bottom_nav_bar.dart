import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/l10n/app_localizations.dart';

enum NavTab { home, services, bookings, updates, settings }

class AppBottomNavBar extends StatelessWidget {
  final NavTab activeTab;
  final ValueChanged<NavTab> onTabChanged;

  const AppBottomNavBar({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Align(
      alignment: Alignment.bottomCenter,
      heightFactor: 1.0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.65), // Translucent liquid glass
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(color: AppColors.outline.withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _NavItem(
                          icon: Icons.home_outlined,
                          activeIcon: Icons.home_rounded,
                          label: l10n.navHome,
                          tab: NavTab.home,
                          activeTab: activeTab,
                          onTap: () => onTabChanged(NavTab.home),
                        ),
                      ),
                      Expanded(
                        child: _NavItem(
                          icon: Icons.build_outlined,
                          activeIcon: Icons.build_rounded,
                          label: l10n.navServices,
                          tab: NavTab.services,
                          activeTab: activeTab,
                          onTap: () => onTabChanged(NavTab.services),
                        ),
                      ),
                      Expanded(
                        child: _NavItem(
                          icon: Icons.event_available_outlined,
                          activeIcon: Icons.event_available_rounded,
                          label: l10n.navBookings,
                          tab: NavTab.bookings,
                          activeTab: activeTab,
                          onTap: () => onTabChanged(NavTab.bookings),
                        ),
                      ),
                      Expanded(
                        child: _NavItem(
                          icon: Icons.notifications_outlined,
                          activeIcon: Icons.notifications_rounded,
                          label: l10n.navUpdates,
                          tab: NavTab.updates,
                          activeTab: activeTab,
                          onTap: () => onTabChanged(NavTab.updates),
                          badge: 2,
                        ),
                      ),
                      Expanded(
                        child: _NavItem(
                          icon: Icons.settings_outlined,
                          activeIcon: Icons.settings_rounded,
                          label: l10n.settings,
                          tab: NavTab.settings,
                          activeTab: activeTab,
                          onTap: () => onTabChanged(NavTab.settings),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final NavTab tab;
  final NavTab activeTab;
  final VoidCallback onTap;
  final int? badge;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.tab,
    required this.activeTab,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = tab == activeTab;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary.withValues(alpha: 0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  size: 22,
                  color: isActive ? AppColors.primary : const Color(0xFF94A3B8),
                ),
                if (badge != null && badge! > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surface, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          '$badge',
                          style: GoogleFonts.urbanist(
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: GoogleFonts.urbanist(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              color: isActive ? AppColors.primary : const Color(0xFF94A3B8),
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}
