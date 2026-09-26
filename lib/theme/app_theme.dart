import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Builds the app's light and dark [ThemeData]. Typography leans on tight
/// tracking and heavy weights for a coach's-whistle, athletic feel, with
/// tabular figures reserved for the countdown digits themselves.
class AppTheme {
  AppTheme._();

  static ThemeData light = _base(
    brightness: Brightness.light,
    background: AppColors.paper,
    surface: AppColors.paperElevated,
    onBackground: AppColors.slate,
  );

  static ThemeData dark = _base(
    brightness: Brightness.dark,
    background: AppColors.ink,
    surface: AppColors.inkElevated,
    onBackground: AppColors.chalk,
  );

  static ThemeData _base({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color onBackground,
  }) {
    final base = ThemeData(brightness: brightness, useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: background,
      colorScheme: base.colorScheme.copyWith(
        brightness: brightness,
        primary: AppColors.volt,
        onPrimary: AppColors.slate,
        surface: surface,
        onSurface: onBackground,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: onBackground,
        titleTextStyle: TextStyle(
          color: onBackground,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: onBackground,
        displayColor: onBackground,
      ),
      iconTheme: IconThemeData(color: onBackground),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.volt,
          foregroundColor: AppColors.slate,
          minimumSize: const Size.fromHeight(58),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
          elevation: 0,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
