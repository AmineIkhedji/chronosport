/// Formats a duration in seconds as "mm:ss", or "Xs" when under a minute
/// and the seconds are a round number worth reading plainly.
String formatClock(int totalSeconds) {
  final s = totalSeconds.clamp(0, 359999);
  final m = (s ~/ 60).toString().padLeft(2, '0');
  final ss = (s % 60).toString().padLeft(2, '0');
  return '$m:$ss';
}

/// A shorter, human label used in compact spots (chips, previews):
/// "20s", "1min30", "3min".
String formatShort(int totalSeconds) {
  if (totalSeconds < 60) return '${totalSeconds}s';
  final m = totalSeconds ~/ 60;
  final s = totalSeconds % 60;
  return s == 0 ? '${m}min' : '${m}min$s';
}

/// A longer label for totals, e.g. "18 min" or "1 h 05".
String formatTotal(int totalSeconds) {
  final h = totalSeconds ~/ 3600;
  final m = (totalSeconds % 3600) ~/ 60;
  final s = totalSeconds % 60;
  if (h > 0) return '${h} h ${m.toString().padLeft(2, '0')}';
  if (m > 0) return s == 0 ? '$m min' : '$m min $s s';
  return '$s s';
}
