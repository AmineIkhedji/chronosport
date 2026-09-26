/// The three kinds of interval a session can be made of.
enum StepType { seance, pause, grandePause }

/// A single interval in a workout session (one "séance", one "pause", ...).
class TimerStep {
  final String label;
  final int duration; // seconds
  final StepType type;

  const TimerStep(this.label, this.duration, this.type);
}
