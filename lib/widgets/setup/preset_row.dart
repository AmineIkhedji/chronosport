import 'package:flutter/material.dart';

import '../../models/session_preset.dart';
import '../../theme/app_colors.dart';

/// Horizontal, scrollable row of preset chips for one-tap setup.
class PresetRow extends StatelessWidget {
  final SessionPreset? selected;
  final ValueChanged<SessionPreset> onSelected;

  const PresetRow({super.key, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: kSessionPresets.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final preset = kSessionPresets[i];
          final isSelected = selected?.name == preset.name;
          return InkWell(
            onTap: () => onSelected(preset),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.volt : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.volt : AppColors.graphite.withOpacity(0.35),
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    preset.icon,
                    size: 15,
                    color: isSelected ? AppColors.slate : AppColors.graphite,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    preset.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppColors.slate
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
