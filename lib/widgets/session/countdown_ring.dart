import 'package:flutter/material.dart';

/// A circular progress ring around the countdown digits, drawn with
/// [CustomPainter] instead of a flat colored disc — the ring drains as
/// the interval elapses, so progress is visible at a glance.
class CountdownRing extends StatelessWidget {
  final int timeLeft;
  final int totalDuration;
  final Color color;
  final String label;
  final String formattedTime;
  final double size;

  const CountdownRing({
    super.key,
    required this.timeLeft,
    required this.totalDuration,
    required this.color,
    required this.label,
    required this.formattedTime,
    this.size = 260,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalDuration == 0 ? 0.0 : timeLeft / totalDuration;
    final onBackground = Theme.of(context).colorScheme.onSurface;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(progress: progress, color: color),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formattedTime,
                style: TextStyle(
                  fontSize: size * 0.215,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  color: onBackground,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _RingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 12.0;
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final track = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final arc = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // start at top (-90deg)
      6.2832 * progress.clamp(0.0, 1.0), // 2*pi * progress
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
