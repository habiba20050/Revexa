import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revexa/shared/extensions/context_extensions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/constants/app_routes.dart';
import 'package:revexa/core/constants/app_constants.dart';
import 'package:revexa/shared/widgets/app_image.dart';
import 'package:revexa/shared/widgets/settings_preference_tiles.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_state.dart';
import 'package:revexa/features/auth/data/models/auth_user_model.dart';
import 'package:revexa/l10n/app_localizations.dart';
import 'package:revexa/core/network/user_management_screen.dart';

import 'package:revexa/shared/theme/theme_cubit.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;
  const ProfileScreen({super.key, this.onBackToHome});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().refreshProfile();
    });
  }

  void _confirmLogout(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (dialogCtx, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.outline.withValues(alpha: 0.8), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 40,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.isDark ? const Color(0xFFB91C1C) : const Color(0xFFFCA5A5),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.power_settings_new_rounded,
                        color: AppColors.isDark ? const Color(0xFFFCA5A5) : const Color(0xFFEF4444),
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.confirmSignOut,
                      style: GoogleFonts.urbanist(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.confirmSignOutMessage,
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.pop(dialogCtx),
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.outline),
                              ),
                              child: Center(
                                child: Text(
                                  l10n.cancel,
                                  style: GoogleFonts.urbanist(
                                    color: AppColors.onSurface,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(dialogCtx);
                              context.read<AuthCubit>().logout();
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  l10n.signOut,
                                  style: GoogleFonts.urbanist(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLarge = context.isTabletOrLarger;
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, _) {
        return BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final user = state is AuthAuthenticated ? state.user : null;
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: AppColors.primary,
                elevation: 0,
                leading: widget.onBackToHome != null
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        onPressed: widget.onBackToHome,
                      )
                    : (Navigator.canPop(context)
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                            onPressed: () => Navigator.pop(context),
                          )
                        : null),
                title: Text(
                  l10n.profileTitle,
                  style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                centerTitle: true,
              ),
              body: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1024),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: isLarge
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left Pane
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _ProfileHeader(user: user),
                                      const SizedBox(height: 24),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _AccountShortcutCard(
                                              icon: Icons.directions_car_outlined,
                                              title: l10n.myVehicles,
                                              subtitle: l10n.myVehiclesSubtitle,
                                              onTap: () => Navigator.pushNamed(context, AppRoutes.myVehicles),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _AccountShortcutCard(
                                              icon: Icons.credit_card_outlined,
                                              title: l10n.payments,
                                              subtitle: l10n.paymentsSubtitle,
                                              onTap: () => Navigator.pushNamed(context, AppRoutes.billing),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      _SectionHeader(title: l10n.accountManagement),
                                      _InfoTile(
                                        icon: Icons.email_outlined,
                                        label: l10n.emailAddress,
                                        value: user?.email ?? '—',
                                      ),
                                      _InfoTile(
                                        icon: Icons.phone_outlined,
                                        label: l10n.phoneNumber,
                                        value: (user?.phone?.isNotEmpty == true) ? user!.phone! : 'Not set',
                                      ),
                                      _InfoTile(
                                        icon: Icons.home_outlined,
                                        label: l10n.address,
                                        value: (user?.address?.isNotEmpty == true) ? user!.address! : 'Not set',
                                      ),
                                      _ProfileMenuItem(
                                        icon: Icons.location_on_outlined,
                                        title: l10n.addresses,
                                        subtitle: l10n.addressesSubtitle,
                                        onTap: () => Navigator.pushNamed(context, AppRoutes.addresses),
                                      ),
                                      if (user?.role == 'admin')
                                        _ProfileMenuItem(
                                          icon: Icons.admin_panel_settings_outlined,
                                          title: l10n.userManagement,
                                          subtitle: '',
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const UserManagementScreen()),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                // Right Pane
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _SectionHeader(title: l10n.preferences),
                                      _ToggleRow(
                                        icon: Icons.notifications_active_outlined,
                                        title: 'Push Notifications',
                                        subtitle: 'Service alerts and booking reminders',
                                        value: _notificationsEnabled,
                                        onChanged: (v) => setState(() => _notificationsEnabled = v),
                                      ),
                                      const SizedBox(height: 8),
                                      const SettingsThemeTile(),
                                      const SettingsLanguageTile(),
                                      const SizedBox(height: 24),
                                      const _SectionHeader(title: 'Support & Security'),
                                      _SecurityPrivacyCard(),
                                      _HelpCenterCard(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _SupportBtn(
                                              icon: Icons.mail_outline_rounded,
                                              label: 'Contact Us',
                                              onTap: () {},
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _SupportBtn(
                                              icon: Icons.info_outline_rounded,
                                              label: 'About',
                                              onTap: () {},
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 32),
                                      _LogoutButton(
                                        onLogout: () => _confirmLogout(context),
                                      ),
                                      const SizedBox(height: 20),
                                      Center(
                                        child: Text(
                                          'Revexa Premium v4.2.0 • Build 2026.06.26',
                                          style: GoogleFonts.urbanist(fontSize: 10, color: AppColors.onSurfaceVariant),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ProfileHeader(user: user),
                              const SizedBox(height: 24),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _AccountShortcutCard(
                                            icon: Icons.directions_car_outlined,
                                            title: l10n.myVehicles,
                                            subtitle: l10n.myVehiclesSubtitle,
                                            onTap: () => Navigator.pushNamed(context, AppRoutes.myVehicles),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _AccountShortcutCard(
                                            icon: Icons.credit_card_outlined,
                                            title: l10n.payments,
                                            subtitle: l10n.paymentsSubtitle,
                                            onTap: () => Navigator.pushNamed(context, AppRoutes.billing),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    _SectionHeader(title: l10n.accountManagement),
                                    _InfoTile(
                                      icon: Icons.email_outlined,
                                      label: l10n.emailAddress,
                                      value: user?.email ?? '—',
                                    ),
                                    _InfoTile(
                                      icon: Icons.phone_outlined,
                                      label: l10n.phoneNumber,
                                      value: (user?.phone?.isNotEmpty == true) ? user!.phone! : 'Not set',
                                    ),
                                    _InfoTile(
                                      icon: Icons.home_outlined,
                                      label: l10n.address,
                                      value: (user?.address?.isNotEmpty == true) ? user!.address! : 'Not set',
                                    ),
                                    _ProfileMenuItem(
                                      icon: Icons.location_on_outlined,
                                      title: l10n.addresses,
                                      subtitle: l10n.addressesSubtitle,
                                      onTap: () => Navigator.pushNamed(context, AppRoutes.addresses),
                                    ),
                                    if (user?.role == 'admin')
                                      _ProfileMenuItem(
                                        icon: Icons.admin_panel_settings_outlined,
                                        title: l10n.userManagement,
                                        subtitle: "",
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const UserManagementScreen()),
                                        ),
                                      ),
                                    const SizedBox(height: 24),
                                    _SectionHeader(title: l10n.preferences),
                                    _ToggleRow(
                                      icon: Icons.notifications_active_outlined,
                                      title: 'Push Notifications',
                                      subtitle: 'Service alerts and booking reminders',
                                      value: _notificationsEnabled,
                                      onChanged: (v) => setState(() => _notificationsEnabled = v),
                                    ),
                                    const SizedBox(height: 8),
                                    const SettingsThemeTile(),
                                    const SettingsLanguageTile(),
                                    const SizedBox(height: 24),
                                    const _SectionHeader(title: 'Support & Security'),
                                    _SecurityPrivacyCard(),
                                    _HelpCenterCard(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _SupportBtn(
                                            icon: Icons.mail_outline_rounded,
                                            label: 'Contact Us',
                                            onTap: () {},
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _SupportBtn(
                                            icon: Icons.info_outline_rounded,
                                            label: 'About',
                                            onTap: () {},
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 32),
                                    _LogoutButton(
                                      onLogout: () => _confirmLogout(context),
                                    ),
                                    const SizedBox(height: 20),
                                    Center(
                                      child: Text(
                                        'Revexa Premium v4.2.0 • Build 2026.06.26',
                                        style: GoogleFonts.urbanist(fontSize: 10, color: AppColors.onSurfaceVariant),
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final AuthUser? user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final imageUrl = user?.imageUrl;
    final isLarge = MediaQuery.of(context).size.width >= 600;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: isLarge
            ? BorderRadius.circular(24)
            : const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              AppCircleAvatar(
                imageUrl: imageUrl,
                radius: 48,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                fallback: Text(
                  user?.firstName.isNotEmpty == true ? user!.firstName[0].toUpperCase() : 'U',
                  style: GoogleFonts.urbanist(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user?.fullName ?? 'User',
            style: GoogleFonts.urbanist(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? '',
            style: GoogleFonts.urbanist(fontSize: 14, color: Colors.white.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.workspace_premium, color: Colors.amber, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Gold Member',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
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

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 12),
      child: Text(
        title,
        style: GoogleFonts.urbanist(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppColors.onSurface,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: GoogleFonts.urbanist(fontSize: 11, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(value, style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outline),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                    Text(subtitle, style: GoogleFonts.urbanist(fontSize: 11, color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountShortcutCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AccountShortcutCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.outline),
          boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(height: 12),
            Text(title, style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
            const SizedBox(height: 2),
            Text(subtitle, style: GoogleFonts.urbanist(fontSize: 11, color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({required this.icon, required this.title, required this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.urbanist(fontSize: 11, color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 26,
              decoration: BoxDecoration(
                color: value ? AppColors.primary : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    left: value ? 22 : 2,
                    top: 2,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
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

class _SecurityPrivacyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outline),
          boxShadow: const [BoxShadow(color: Color(0x04000000), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.shield_outlined, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Security & Privacy', style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                  const SizedBox(height: 2),
                  Text('2FA Enabled • Password last changed 30d ago', style: GoogleFonts.urbanist(fontSize: 11, color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}

class _HelpCenterCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 120,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                AppConstants.imgSettingsHelpCenter,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0E7490), Color(0xFF155E75)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xAA000000)],
                    stops: [0.3, 1.0],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Help Center', style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                      Text('Find quick answers and tutorials', style: GoogleFonts.urbanist(fontSize: 11, color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SupportBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.onSurface),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.urbanist(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;
  const _LogoutButton({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return SizedBox(
          height: 54,
          width: double.infinity,
          child: Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
            shadowColor: AppColors.primary.withValues(alpha: 0.25),
            elevation: 4,
            child: InkWell(
              onTap: isLoading ? null : onLogout,
              borderRadius: BorderRadius.circular(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: isLoading
                    ? [const SizedBox(width: 20, height: 20, child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: 2))]
                    : [
                        const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Text('Logout', style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                      ],
              ),
            ),
          ),
        );
      },
    );
  }
}
