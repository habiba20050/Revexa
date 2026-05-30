import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/l10n/app_localizations.dart';
import 'package:revexa/shared/locale/locale_cubit.dart';
import 'package:revexa/shared/theme/theme_cubit.dart';

class SettingsThemeTile extends StatelessWidget {
  const SettingsThemeTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final isDark = themeState.mode == AppThemeMode.dark ||
            (themeState.mode == AppThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);
        return _SettingsPreferenceCard(
          icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
          title: l10n.darkMode,
          subtitle: isDark ? l10n.darkModeCurrent : l10n.lightModeCurrent,
          trailing: GestureDetector(
            onTap: () => context.read<ThemeCubit>().toggleTheme(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 52,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: isDark ? AppColors.primary : AppColors.outline,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.all(3),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SettingsLanguageTile extends StatelessWidget {
  const SettingsLanguageTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return _SettingsPreferenceCard(
          icon: Icons.language_rounded,
          title: l10n.language,
          subtitle: locale.languageCode == 'ar' ? l10n.languageArabic : l10n.languageEnglish,
          trailing: _LanguageSegment(currentLocale: locale),
        );
      },
    );
  }
}

class _SettingsPreferenceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingsPreferenceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Container(
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
    );
  }
}

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
