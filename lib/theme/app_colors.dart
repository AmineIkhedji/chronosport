import 'package:flutter/material.dart';
import '../models/timer_step.dart';

/// Chrono Coach's palette. Inspired by a running track at dusk: an
/// ink-dark ground, chalk lane markings, and the three lit-up interval
/// colors a coach's stopwatch would use — lime for effort, amber for
/// recovery, blue for the long rest.
class AppColors {
  AppColors._();

  static const ink = Color(0xFF14171C); // dark background
  static const inkElevated = Color(0xFF1E222A); // dark surfaces
  static const paper = Color(0xFFF6F5F1); // light background
  static const paperElevated = Color(0xFFFFFFFF); // light surfaces

  static const chalk = Color(0xFFF4F5F6); // light text on dark
  static const slate = Color(0xFF20242B); // dark text on light
  static const graphite = Color(0xFF8C929B); // muted text, both modes

  static const volt = Color(0xFFC6FF3D); // séance / effort
  static const ember = Color(0xFFFF9F45); // pause
  static const horizon = Color(0xFF4FB4FF); // grande pause

  static Color forStep(StepType type) {
    switch (type) {
      case StepType.seance:
        return volt;
      case StepType.pause:
        return ember;
      case StepType.grandePause:
        return horizon;
    }
  }
}
