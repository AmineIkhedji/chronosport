import 'package:flutter/material.dart';
import '../../models/timer_step.dart';
import '../../theme/app_colors.dart';

/// One row in the session timeline: done / active / upcoming, colored by
/// its [StepType].
class StepTile extends StatelessWidget {
  final TimerStep step;
  final bool isDone;
  final bool isActive;

  const StepTile({
    super.key,
    required this.step,
    required this.isDone,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = AppColors.forStep(step.type);
    final color = isDone
        ? AppColors.graphite
        : isActive
            ? accent
            : AppColors.graphite.withOpacity(0.6);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? accent.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: isActive ? Border.all(color: accent.withOpacity(0.35)) : null,
      ),
      child: Row(
        children: [
          Icon(
            isDone
                ? Icons.check_circle
                : isActive
                    ? Icons.play_circle_fill
                    : Icons.circle_outlined,
            color: color,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              step.label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isDone
                    ? theme.colorScheme.onSurface.withOpacity(0.4)
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            '${step.duration}s',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.graphite,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
