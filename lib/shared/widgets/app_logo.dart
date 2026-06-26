import 'package:flutter/material.dart';
import 'package:revexa/core/theme/app_colors.dart';

/// A single, unified logo widget used throughout the application.
/// It provides factory constructors for different standard sizes.
class AppLogo extends StatelessWidget {
  final double cellSize;
  final double spacing;
  final double padding;
  final double borderRadius;
  final bool showBorder;

  const AppLogo({
    super.key,
    required this.cellSize,
    required this.spacing,
    required this.padding,
    required this.borderRadius,
    this.showBorder = true,
  });

  /// Factory constructor for a mini logo suitable for headers / AppBars.
  factory AppLogo.mini() {
    return const AppLogo(
      cellSize: 18.0,
      spacing: 3.0,
      padding: 4.0,
      borderRadius: 4.0,
    );
  }

  /// Factory constructor for a grid logo suitable for splash & onboarding.
  factory AppLogo.grid() {
    return const AppLogo(
      cellSize: 44.0,
      spacing: 8.0,
      padding: 12.0,
      borderRadius: 10.0,
    );
  }

  /// Factory constructor for a large logo suitable for the Sign-In / Register screens.
  factory AppLogo.large() {
    return const AppLogo(
      cellSize: 56.0,
      spacing: 12.0,
      padding: 16.0,
      borderRadius: 12.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius * 2.0),
        border: showBorder ? Border.all(color: AppColors.outline.withValues(alpha: 0.6)) : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: padding,
            offset: Offset(0, padding / 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _GridCell(
                icon: Icons.directions_car_rounded,
                isPrimary: true,
                size: cellSize,
                borderRadius: borderRadius,
              ),
              SizedBox(width: spacing),
              _GridCell(
                icon: Icons.build_rounded,
                isPrimary: false,
                size: cellSize,
                borderRadius: borderRadius,
              ),
            ],
          ),
          SizedBox(height: spacing),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _GridCell(
                icon: Icons.local_car_wash_rounded,
                isPrimary: false,
                size: cellSize,
                borderRadius: borderRadius,
              ),
              SizedBox(width: spacing),
              _GridCell(
                icon: Icons.local_gas_station_rounded,
                isPrimary: false,
                size: cellSize,
                borderRadius: borderRadius,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GridCell extends StatelessWidget {
  final IconData icon;
  final bool isPrimary;
  final double size;
  final double borderRadius;

  const _GridCell({
    required this.icon,
    required this.isPrimary,
    required this.size,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.primary : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: size * 0.15,
                  offset: Offset(0, size * 0.07),
                ),
              ]
            : null,
      ),
      child: Icon(
        icon,
        color: isPrimary ? Colors.white : AppColors.primary,
        size: size * 0.55,
      ),
    );
  }
}
