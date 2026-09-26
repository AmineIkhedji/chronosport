import 'package:flutter/material.dart';

/// App bar action letting the user switch between light, dark and
/// system theme modes.
class ThemeSwitcherMenu extends StatelessWidget {
  final ThemeMode current;
  final ValueChanged<ThemeMode> onChanged;

  const ThemeSwitcherMenu({
    super.key,
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ThemeMode>(
      icon: const Icon(Icons.color_lens_outlined),
      onSelected: onChanged,
      initialValue: current,
      itemBuilder: (_) => const [
        PopupMenuItem(value: ThemeMode.light, child: Text('Clair')),
        PopupMenuItem(value: ThemeMode.dark, child: Text('Sombre')),
        PopupMenuItem(value: ThemeMode.system, child: Text('Système')),
      ],
    );
  }
}
