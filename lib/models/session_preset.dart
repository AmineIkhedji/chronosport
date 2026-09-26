import 'package:flutter/material.dart';
import 'session_config.dart';

/// A named, one-tap starting point for the setup screen. Picking one
/// fills all four fields at once; the user can still fine-tune from there.
class SessionPreset {
  final String name;
  final IconData icon;
  final SessionConfig config;

  const SessionPreset(this.name, this.icon, this.config);
}

const List<SessionPreset> kSessionPresets = [
  SessionPreset(
    'Tabata',
    Icons.flash_on,
    SessionConfig(nbSeances: 8, dureeSeance: 20, pause: 10, grandePause: 60),
  ),
  SessionPreset(
    'HIIT',
    Icons.local_fire_department,
    SessionConfig(nbSeances: 10, dureeSeance: 40, pause: 20, grandePause: 90),
  ),
  SessionPreset(
    'Boxe',
    Icons.sports_mma,
    SessionConfig(nbSeances: 6, dureeSeance: 180, pause: 60, grandePause: 120),
  ),
  SessionPreset(
    'Fractionné',
    Icons.directions_run,
    SessionConfig(nbSeances: 12, dureeSeance: 60, pause: 30, grandePause: 180),
  ),
];
