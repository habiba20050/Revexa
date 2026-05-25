import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/l10n/app_localizations.dart';

enum NavTab { home, services, bookings, updates, profile }

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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A1D3C87),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
        border: const Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Expanded(child: _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: l10n.navHome,
                tab: NavTab.home,
                activeTab: activeTab,
                onTap: () => onTabChanged(NavTab.home),
              )),
              Expanded(child: _NavItem(
                icon: Icons.build_outlined,
                activeIcon: Icons.build_rounded,
                label: l10n.navServices,
                tab: NavTab.services,
                activeTab: activeTab,
                onTap: () => onTabChanged(NavTab.services),
              )),
              Expanded(child: _NavItem(
                icon: Icons.event_available_outlined,
                activeIcon: Icons.event_available_rounded,
                label: l10n.navBookings,
                tab: NavTab.bookings,
                activeTab: activeTab,
                onTap: () => onTabChanged(NavTab.bookings),
              )),
              Expanded(child: _NavItem(
                icon: Icons.notifications_outlined,
                activeIcon: Icons.notifications_rounded,
                label: l10n.navUpdates,
                tab: NavTab.updates,
                activeTab: activeTab,
                onTap: () => onTabChanged(NavTab.updates),
                badge: 2,
              )),
              Expanded(child: _NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: l10n.navProfile,
                tab: NavTab.profile,
                activeTab: activeTab,
                onTap: () => onTabChanged(NavTab.profile),
              )),
            ],
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
      child: SizedBox(
        width: double.infinity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFEEF2FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
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
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$badge',
                          style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.primary : const Color(0xFF94A3B8),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}
