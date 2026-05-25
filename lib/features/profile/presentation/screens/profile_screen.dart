import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/constants/app_routes.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_state.dart';
import 'package:revexa/features/auth/data/models/auth_user_model.dart';
import 'package:revexa/shared/theme/theme_cubit.dart';
import 'package:revexa/shared/locale/locale_cubit.dart';
import 'package:revexa/l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  _ProfileHeader(user: user),
                  const SizedBox(height: 8),

                  // Stats row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        _StatCard(value: '02', label: l10n.vehicles),
                        const SizedBox(width: 12),
                        _StatCard(value: '12', label: l10n.memberships),
                        const SizedBox(width: 12),
                        _StatCard(value: l10n.goldMember, label: l10n.member),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Account Management
                  _SectionHeader(title: l10n.accountManagement),
                  _ProfileMenuItem(
                    icon: Icons.directions_car,
                    title: l10n.myVehicles,
                    subtitle: l10n.myVehiclesSubtitle,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.myVehicles),
                  ),
                  _ProfileMenuItem(
                    icon: Icons.history,
                    title: l10n.serviceHistory,
                    subtitle: l10n.serviceHistorySubtitle,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.bookings),
                  ),
                  _ProfileMenuItem(
                    icon: Icons.payments_outlined,
                    title: l10n.payments,
                    subtitle: l10n.paymentsSubtitle,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.billing),
                  ),
                  _ProfileMenuItem(
                    icon: Icons.location_on_outlined,
                    title: l10n.addresses,
                    subtitle: l10n.addressesSubtitle,
                    onTap: () {},
                  ),

                  const SizedBox(height: 8),

                  // Preferences
                  _SectionHeader(title: l10n.preferences),

                  // Dark Mode Toggle
                  BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, themeState) {
                      final isDark = themeState.mode == AppThemeMode.dark ||
                          (themeState.mode == AppThemeMode.system &&
                              MediaQuery.of(context).platformBrightness == Brightness.dark);
                      return _PreferenceCard(
                        icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        title: l10n.darkMode,
                        subtitle: isDark ? l10n.darkModeCurrent : l10n.lightModeCurrent,
                        trailing: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: 52,
                          height: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: isDark ? AppColors.primary : AppColors.outline,
                          ),
                          child: GestureDetector(
                            onTap: () => context.read<ThemeCubit>().toggleTheme(),
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.all(3),
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(11),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                                  size: 12,
                                  color: isDark ? const Color(0xFF1D3C87) : const Color(0xFFF59E0B),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Language Selector
                  BlocBuilder<LocaleCubit, Locale>(
                    builder: (context, locale) {
                      return _PreferenceCard(
                        icon: Icons.language_rounded,
                        title: l10n.language,
                        subtitle: locale.languageCode == 'ar' ? l10n.languageArabic : l10n.languageEnglish,
                        trailing: _LanguageSegment(currentLocale: locale),
                      );
                    },
                  ),

                  _ProfileMenuItem(
                    icon: Icons.settings_outlined,
                    title: l10n.settings,
                    subtitle: l10n.settingsSubtitle,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                  ),
                  _ProfileMenuItem(
                    icon: Icons.help_outline,
                    title: l10n.helpCenter,
                    subtitle: l10n.helpCenterSubtitle,
                    onTap: () {},
                  ),

                  const SizedBox(height: 8),

                  // Sign out
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: GestureDetector(
                      onTap: () => _confirmLogout(context),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.errorContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.logout_rounded, color: AppColors.error, size: 22),
                            const SizedBox(width: 12),
                            Text(
                              l10n.signOut,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.error,
                              ),
                            ),
                            const Spacer(),
                            Icon(Icons.chevron_right, color: AppColors.error, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    l10n.appVersion,
                    style: GoogleFonts.inter(fontSize: 11, color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.surface,
        title: Text(l10n.confirmSignOut, style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.onSurface)),
        content: Text(l10n.confirmSignOutMessage, style: GoogleFonts.inter(color: AppColors.onSurfaceVariant)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: GoogleFonts.inter(color: AppColors.onSurfaceVariant)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
  }
}

// ─── Language Segmented Control ───────────────────────────────────────────────

class _LanguageSegment extends StatelessWidget {
  final Locale currentLocale;
  const _LanguageSegment({required this.currentLocale});

  @override
  Widget build(BuildContext context) {
    final isEn = currentLocale.languageCode == 'en';
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LangBtn(label: 'EN', selected: isEn, onTap: () => context.read<LocaleCubit>().setLocale('en')),
          const SizedBox(width: 2),
          _LangBtn(label: 'AR', selected: !isEn, onTap: () => context.read<LocaleCubit>().setLocale('ar')),
        ],
      ),
    );
  }
}

class _LangBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _LangBtn({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ─── Preference Card (generic row with custom trailing) ────────────────────

class _PreferenceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  const _PreferenceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                  Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

// ─── Profile Header ────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final AuthUser? user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 3),
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              child: Text(
                user?.firstName.isNotEmpty == true ? user!.firstName[0].toUpperCase() : 'U',
                style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.fullName ?? 'User',
                  style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(user?.email ?? '', style: GoogleFonts.inter(fontSize: 13, color: Colors.white70)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.neon.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.workspace_premium, color: AppColors.neon, size: 14),
                    const SizedBox(width: 4),
                    Text(l10n.goldMember, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.neon)),
                  ]),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.editProfile),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stat Card ─────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outline),
        ),
        child: Column(
          children: [
            Text(value, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary)),
            Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

// ─── Section Header ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// ─── Profile Menu Item ──────────────────────────────────────────────────────

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outline),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                    Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
