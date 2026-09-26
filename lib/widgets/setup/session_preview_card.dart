import 'package:flutter/material.dart';

import '../../models/session_config.dart';
import '../../theme/app_colors.dart';
import '../../utils/duration_format.dart';

/// A horizontal, proportional bar showing every interval of the
/// configured session at a glance, plus the total time — so the user
/// sees the shape of their workout instantly, before pressing start.
class SessionPreviewCard extends StatelessWidget {
  final SessionConfig config;

  const SessionPreviewCard({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final steps = config.buildSteps();
    final total = config.totalSeconds.clamp(1, 1 << 30);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Aperçu',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.graphite,
                ),
              ),
              Text(
                'Durée totale : ${formatTotal(config.totalSeconds)}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 14,
              child: Row(
                children: steps
                    .where((s) => s.duration > 0)
                    .map(
                      (s) => Expanded(
                        flex: s.duration,
                        child: Container(
                          color: AppColors.forStep(s.type),
                          margin: const EdgeInsets.only(right: 1.5),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            runSpacing: 4,
            children: [
              _Legend(color: AppColors.volt, label: '${config.nbSeances} × ${formatShort(config.dureeSeance)}'),
              if (config.pause > 0) _Legend(color: AppColors.ember, label: 'Pause ${formatShort(config.pause)}'),
              if (config.grandePause > 0)
                _Legend(color: AppColors.horizon, label: 'Grande pause ${formatShort(config.grandePause)}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
          ),
        ),
      ],
    );
  }
}
