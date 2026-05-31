import 'package:flutter/material.dart';
import 'package:revexa/core/theme/app_colors.dart';

/// Small 4-icon 2x2 grid logo used in headers
class AppLogoMini extends StatelessWidget {
  const AppLogoMini({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.10)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LogoIconCell(icon: Icons.directions_car),
              SizedBox(width: 2),
              _LogoIconCell(icon: Icons.build),
            ],
          ),
          SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LogoIconCell(icon: Icons.local_car_wash),
              SizedBox(width: 2),
              _LogoIconCell(icon: Icons.local_gas_station),
            ],
          ),
        ],
      ),
    );
  }
}

class _LogoIconCell extends StatelessWidget {
  final IconData icon;
  const _LogoIconCell({required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: Center(
        child: Icon(icon, color: AppColors.primary, size: 11),
      ),
    );
  }
}

/// Medium 4-icon grid logo used on register/splash screens
class AppLogoGrid extends StatelessWidget {
  const AppLogoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _GridIcon(
                icon: Icons.directions_car,
                bg: AppColors.primary.withValues(alpha: 0.10),
                iconColor: AppColors.primary,
              ),
              const SizedBox(width: 8),
              _GridIcon(
                icon: Icons.build,
                bg: AppColors.primary,
                iconColor: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _GridIcon(
                icon: Icons.local_car_wash,
                bg: AppColors.primary,
                iconColor: Colors.white,
              ),
              const SizedBox(width: 8),
              _GridIcon(
                icon: Icons.local_gas_station,
                bg: AppColors.primary.withValues(alpha: 0.10),
                iconColor: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GridIcon extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color iconColor;

  const _GridIcon({required this.icon, required this.bg, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: iconColor, size: 22),
    );
  }
}

/// Large 4-icon grid for Sign-In screen (56x56 cells)
class AppLogoLarge extends StatelessWidget {
  const AppLogoLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LargeIcon(
              icon: Icons.directions_car,
              bg: AppColors.primary,
              iconColor: Colors.white,
            ),
      const      SizedBox(width: 12),
            _LargeIcon(
              icon: Icons.build,
              bg: AppColors.surfaceContainerHigh,
              iconColor: AppColors.primary,
            ),
          ],
        ),
  const      SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LargeIcon(
              icon: Icons.home_repair_service,
              bg: AppColors.surfaceContainerHigh,
              iconColor: AppColors.primary,
            ),
          const  SizedBox(width: 12),
            _LargeIcon(
              icon: Icons.local_gas_station,
              bg: AppColors.surfaceContainerHigh,
              iconColor: AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }
}

class _LargeIcon extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color iconColor;

  const _LargeIcon({required this.icon, required this.bg, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: bg == AppColors.primary
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.20),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Icon(icon, color: iconColor, size: 28),
    );
  }
}
