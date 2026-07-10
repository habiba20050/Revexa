import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/l10n/app_localizations.dart';

/// A simple placeholder company dashboard screen for company users.
class CompanyDashboardScreen extends StatelessWidget {
  const CompanyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          l10n.addServiceTitle,
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
      ),
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          l10n.serviceAddedSuccessfully,
          textAlign: TextAlign.center,
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}
