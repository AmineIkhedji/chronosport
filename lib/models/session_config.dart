import 'timer_step.dart';

/// The user-entered parameters that define a workout session.
class SessionConfig {
  final int nbSeances;
  final int dureeSeance;
  final int pause;
  final int grandePause;

  const SessionConfig({
    required this.nbSeances,
    required this.dureeSeance,
    required this.pause,
    required this.grandePause,
  });

  bool get isValid =>
      nbSeances > 0 && dureeSeance > 0 && pause >= 0 && grandePause >= 0;

  /// Total time the session will take, in seconds, including every
  /// interval and pause.
  int get totalSeconds {
    if (nbSeances <= 0) return grandePause;
    return nbSeances * dureeSeance + (nbSeances - 1) * pause + grandePause;
  }

  SessionConfig copyWith({
    int? nbSeances,
    int? dureeSeance,
    int? pause,
    int? grandePause,
  }) =>
      SessionConfig(
        nbSeances: nbSeances ?? this.nbSeances,
        dureeSeance: dureeSeance ?? this.dureeSeance,
        pause: pause ?? this.pause,
        grandePause: grandePause ?? this.grandePause,
      );

  Map<String, dynamic> toJson() => {
        'nb': nbSeances,
        'duree': dureeSeance,
        'pause': pause,
        'grandePause': grandePause,
      };

  factory SessionConfig.fromJson(Map<String, dynamic> json) => SessionConfig(
        nbSeances: json['nb'] as int,
        dureeSeance: json['duree'] as int,
        pause: json['pause'] as int,
        grandePause: json['grandePause'] as int,
      );

  /// Expands this config into the ordered list of intervals for the session.
  List<TimerStep> buildSteps() {
    final steps = <TimerStep>[];
    for (int i = 0; i < nbSeances; i++) {
      steps.add(TimerStep('Séance ${i + 1}', dureeSeance, StepType.seance));
      if (i < nbSeances - 1) {
        steps.add(TimerStep('Pause ${i + 1}', pause, StepType.pause));
      }
    }
    steps.add(TimerStep('Grande pause', grandePause, StepType.grandePause));
    return steps;
  }
}
