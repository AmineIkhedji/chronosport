import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// The pause / resume pill button shown under the countdown ring.
class SessionControls extends StatelessWidget {
  final bool isPaused;
  final bool isDone;
  final VoidCallback onToggle;

  const SessionControls({
    super.key,
    required this.isPaused,
    required this.isDone,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 54,
      child: ElevatedButton.icon(
        icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
        label: Text(isPaused ? 'Reprendre' : 'Pause'),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPaused ? AppColors.volt : AppColors.ink,
          foregroundColor: isPaused ? AppColors.slate : AppColors.chalk,
          disabledBackgroundColor: AppColors.graphite.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
          elevation: 0,
        ),
        onPressed: isDone ? null : onToggle,
      ),
    );
  }
}
