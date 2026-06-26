import 'package:flutter/material.dart';
import 'package:revexa/core/theme/app_colors.dart';

extension ContextExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  ThemeData get theme => Theme.of(this);
  bool get isTabletOrLarger => screenWidth >= 600;

  /// Shows a SnackBar using the ROOT ScaffoldMessenger so it is always
  /// visible, even when called from a nested Scaffold inside HomeScreen
  /// (which uses extendBody: true and a floating bottom nav bar).
  void showAppSnackBar(
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppColors.error : const Color(0xFF22C55E),
          behavior: SnackBarBehavior.floating,
          // Extra bottom margin so the SnackBar clears the floating nav bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(this).padding.bottom + 80,
            left: 16,
            right: 16,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: duration,
        ),
      );
  }
}
