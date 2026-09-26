import 'package:flutter/material.dart';

import '../../models/session_config.dart';
import '../../models/session_preset.dart';
import '../../services/config_storage_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/duration_format.dart';
import '../../widgets/setup/preset_row.dart';
import '../../widgets/setup/session_preview_card.dart';
import '../../widgets/setup/theme_switcher_menu.dart';
import '../../widgets/setup/value_stepper_card.dart';
import '../session/timer_session_view.dart';

const _defaultConfig = SessionConfig(nbSeances: 8, dureeSeance: 30, pause: 15, grandePause: 60);

class TimerSetupView extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const TimerSetupView({
    super.key,
    required this.currentThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<TimerSetupView> createState() => _TimerSetupViewState();
}

class _TimerSetupViewState extends State<TimerSetupView> {
  final _storage = const ConfigStorageService();
  SessionConfig _config = _defaultConfig;
  SessionPreset? _activePreset;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _storage.read().then((saved) {
      setState(() {
        if (saved != null) _config = saved;
        _loaded = true;
      });
    });
  }

  void _apply(SessionConfig next) {
    setState(() {
      _config = next;
      _activePreset = null;
    });
  }

  void _applyPreset(SessionPreset preset) {
    setState(() {
      _config = preset.config;
      _activePreset = preset;
    });
  }

  void _launch() {
    if (!_config.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Remplis correctement tous les champs')),
      );
      return;
    }
    _storage.save(_config);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TimerSessionView(config: _config)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chrono Coach'),
        actions: [
          ThemeSwitcherMenu(
            current: widget.currentThemeMode,
            onChanged: widget.onThemeChanged,
          ),
        ],
      ),
      body: _loaded ? _buildBody(context) : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 720;
          final maxContentWidth = isWide ? 760.0 : constraints.maxWidth;

          return Column(
            children: [
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxContentWidth),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                      children: [
                        const Text(
                          'Prépare ta séance',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.6),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Choisis un format ou règle tes intervalles toi-même.',
                          style: TextStyle(fontSize: 14, color: AppColors.graphite),
                        ),
                        const SizedBox(height: 16),
                        PresetRow(selected: _activePreset, onSelected: _applyPreset),
                        const SizedBox(height: 20),
                        _ParamGrid(config: _config, isWide: isWide, onChanged: _apply),
                        const SizedBox(height: 16),
                        SessionPreviewCard(config: _config),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
              _LaunchBar(config: _config, maxWidth: maxContentWidth, onLaunch: _launch),
            ],
          );
        },
      ),
    );
  }
}

/// Lays the four stepper cards out as one column on phones, two on wider
/// screens (tablet / desktop / web), without ever changing which widget
/// holds which field.
class _ParamGrid extends StatelessWidget {
  final SessionConfig config;
  final bool isWide;
  final ValueChanged<SessionConfig> onChanged;

  const _ParamGrid({required this.config, required this.isWide, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cards = [
      ValueStepperCard(
        title: 'Nombre de séances',
        icon: Icons.repeat,
        accent: AppColors.volt,
        value: config.nbSeances,
        min: 1,
        max: 30,
        step: 1,
        formatter: (v) => '$v',
        onChanged: (v) => onChanged(config.copyWith(nbSeances: v)),
      ),
      ValueStepperCard(
        title: 'Durée séance',
        icon: Icons.bolt,
        accent: AppColors.volt,
        value: config.dureeSeance,
        min: 5,
        max: 600,
        step: 5,
        formatter: formatClock,
        onChanged: (v) => onChanged(config.copyWith(dureeSeance: v)),
      ),
      ValueStepperCard(
        title: 'Pause',
        icon: Icons.pause_circle_outline,
        accent: AppColors.ember,
        value: config.pause,
        min: 0,
        max: 300,
        step: 5,
        formatter: formatClock,
        onChanged: (v) => onChanged(config.copyWith(pause: v)),
      ),
      ValueStepperCard(
        title: 'Grande pause',
        icon: Icons.self_improvement,
        accent: AppColors.horizon,
        value: config.grandePause,
        min: 0,
        max: 600,
        step: 5,
        formatter: formatClock,
        onChanged: (v) => onChanged(config.copyWith(grandePause: v)),
      ),
    ];

    if (!isWide) {
      return Column(
        children: [for (final c in cards) Padding(padding: const EdgeInsets.only(bottom: 12), child: c)],
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final c in cards)
          SizedBox(width: (760 - 12) / 2, child: c),
      ],
    );
  }
}

/// Sticky footer: always-visible total time and launch button, so the
/// call to action never gets lost in the scroll.
class _LaunchBar extends StatelessWidget {
  final SessionConfig config;
  final double maxWidth;
  final VoidCallback onLaunch;

  const _LaunchBar({required this.config, required this.maxWidth, required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.brightness == Brightness.dark
                ? Colors.white.withOpacity(0.06)
                : Colors.black.withOpacity(0.05),
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${config.nbSeances} séances · ${formatTotal(config.totalSeconds)}',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.graphite),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 190,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Lancer'),
                  onPressed: onLaunch,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
