import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:revexa/core/theme/app_colors.dart';

enum AppThemeMode { light, dark, system }

class ThemeState extends Equatable {
  final AppThemeMode mode;

  const ThemeState(this.mode);

  ThemeMode get themeMode {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  @override
  List<Object?> get props => [mode];
}

class ThemeCubit extends Cubit<ThemeState> {
  static const _key = 'app_theme_mode';

  ThemeCubit() : super(const ThemeState(AppThemeMode.system));

  @override
  void onChange(Change<ThemeState> change) {
    super.onChange(change);
    final mode = change.nextState.mode;
    AppColors.isDark = mode == AppThemeMode.dark ||
        (mode == AppThemeMode.system &&
            WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark);
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key) ?? 'system';
    final mode = AppThemeMode.values.firstWhere(
      (e) => e.name == stored,
      orElse: () => AppThemeMode.system,
    );
    emit(ThemeState(mode));
  }

  Future<void> setTheme(AppThemeMode mode) async {
    emit(ThemeState(mode)); // Rebuild the UI instantly!
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(_key, mode.name);
    });
  }

  Future<void> toggleTheme() async {
    final next = state.mode == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light;
    setTheme(next); // No await needed for writing to finish
  }
}
