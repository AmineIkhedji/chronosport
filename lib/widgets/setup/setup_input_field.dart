import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// A flat, rounded input row used on the setup screen — replaces the
/// default [Card] look with something that matches the app's own
/// surfaces instead of Material's generic elevation shadow.
class SetupInputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String suffix;
  final Color accent;

  const SetupInputField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.accent,
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accent, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                labelText: label,
                suffixText: suffix.isEmpty ? null : suffix,
                border: InputBorder.none,
                labelStyle: TextStyle(color: AppColors.graphite, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
