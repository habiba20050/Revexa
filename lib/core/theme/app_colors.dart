import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static bool isDark = false;

  // Brand
  static Color get primary => isDark ? const Color(0xFF6B8FFF) : const Color(0xFF1D3C87);
  static Color get neon => const Color(0xFF06B6D4);
  static Color get electric => const Color(0xFF2563EB);

  // Background
  static Color get background => isDark ? const Color(0xFF0F172A) : const Color(0xFFF6F6F8);
  static Color get surface => isDark ? const Color(0xFF1E2432) : const Color(0xFFFFFFFF);
  static Color get surfaceContainerLow => isDark ? const Color(0xFF151B28) : const Color(0xFFF8F9FC);
  static Color get surfaceContainer => isDark ? const Color(0xFF1A2130) : const Color(0xFFF1F3F9);
  static Color get surfaceContainerHigh => isDark ? const Color(0xFF242A38) : const Color(0xFFE7EAF2);
  static Color get surfaceContainerHighest => isDark ? const Color(0xFF2D3748) : const Color(0xFFDEE2EE);
  static Color get surfaceVariant => isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
  static Color get surfaceDim => isDark ? const Color(0xFF0F172A) : const Color(0xFFF6F6F8);

  // On-surface
  static Color get onSurface => isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
  static Color get onBackground => isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
  static Color get onSurfaceVariant => isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  static Color get onPrimary => isDark ? const Color(0xFFFFFFFF) : const Color(0xFFFFFFFF);

  // Outline
  static Color get outline => isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0);
  static Color get outlineVariant => isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1);

  // Secondary
  static Color get secondary => isDark ? const Color(0xFF94A3B8) : const Color(0xFF334155);
  static Color get secondaryContainer => isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
  static Color get onSecondaryContainer => isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);

  // Error
  static Color get error => const Color(0xFFEF4444);
  static Color get errorContainer => isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);

  // Inverse
  static Color get inverseSurface => isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B);

  // Primary containers
  static Color get primaryFixed => isDark ? const Color(0xFF2A3F7A) : const Color(0xFFDBE1FF);
  static Color get primaryFixedDim => isDark ? const Color(0xFF3D57A5) : const Color(0xFFB4C5FF);
  static Color get primaryContainer => isDark ? const Color(0xFF1E293B) : const Color(0xFF1D3C87);
  static Color get onPrimaryContainer => isDark ? const Color(0xFFE2E8F0) : const Color(0xFFFFFFFF);

  // Tertiary
  static Color get tertiaryFixed => isDark ? const Color(0xFF7A3A15) : const Color(0xFFFFDBCA);
  static Color get onTertiaryFixedVariant => isDark ? const Color(0xFFFFDBCA) : const Color(0xFF753405);
}
