import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../models/session_config.dart';
import '../models/timer_step.dart';

/// Owns the countdown state machine for a workout session: which step is
/// active, how much time is left, pause/resume, and cue sounds. Kept
/// completely free of widgets so it can be unit-tested on its own.
class SessionController extends ChangeNotifier {
  SessionController(SessionConfig config) : steps = config.buildSteps() {
    _start();
  }

  final List<TimerStep> steps;
  final AudioPlayer _player = AudioPlayer();
  Timer? _timer;

  int _index = 0;
  int _timeLeft = 0;
  bool _isPaused = false;

  int get index => _index;
  int get timeLeft => _timeLeft;
  bool get isPaused => _isPaused;
  bool get isDone => _index >= steps.length;
  TimerStep? get current => isDone ? null : steps[_index];
  TimerStep? get next =>
      (!isDone && _index + 1 < steps.length) ? steps[_index + 1] : null;

  void _start() {
    if (_index >= steps.length) return;
    _timeLeft = steps[_index].duration;
    _isPaused = false;
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isPaused) _tick();
    });
  }

  void _tick() {
    _timeLeft--;

    if (_timeLeft <= 5 && _timeLeft > 0) {
      _player.play(AssetSource('sounds/beep.mp3'));
    }

    if (_timeLeft == 0) {
      _player.play(AssetSource('sounds/final_beep.mp3'));
      _timer?.cancel();
      _index++;
      if (_index < steps.length) {
        _start();
        return;
      }
    }
    notifyListeners();
  }

  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    super.dispose();
  }
}
