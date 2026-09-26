import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'views/setup/timer_setup_view.dart';

class ChronoApp extends StatefulWidget {
  const ChronoApp({super.key});

  @override
  State<ChronoApp> createState() => _ChronoAppState();
}

class _ChronoAppState extends State<ChronoApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chrono Coach',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: TimerSetupView(
        currentThemeMode: _themeMode,
        onThemeChanged: (mode) => setState(() => _themeMode = mode),
      ),
    );
  }
}
