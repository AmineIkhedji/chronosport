import 'package:flutter/material.dart';

import '../../controllers/session_controller.dart';
import '../../models/session_config.dart';
import '../../theme/app_colors.dart';
import '../../utils/duration_format.dart';
import '../../widgets/session/countdown_ring.dart';
import '../../widgets/session/session_controls.dart';
import '../../widgets/session/step_tile.dart';

class TimerSessionView extends StatefulWidget {
  final SessionConfig config;

  const TimerSessionView({super.key, required this.config});

  @override
  State<TimerSessionView> createState() => _TimerSessionViewState();
}

class _TimerSessionViewState extends State<TimerSessionView> {
  late final SessionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SessionController(widget.config)..addListener(_onChange);
  }

  void _onChange() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_onChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Séance en cours')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 760;
            return isWide ? _wideLayout(context) : _narrowLayout(context);
          },
        ),
      ),
    );
  }

  Widget _narrowLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        children: [
          _HeroPanel(controller: _controller, ringSize: 240),
          const SizedBox(height: 20),
          _TimelineHeader(),
          const SizedBox(height: 8),
          Expanded(child: _Timeline(controller: _controller)),
        ],
      ),
    );
  }

  Widget _wideLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: Center(child: _HeroPanel(controller: _controller, ringSize: 300)),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimelineHeader(),
                const SizedBox(height: 8),
                Expanded(child: _Timeline(controller: _controller)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The countdown ring, current/next labels and pause control — the part
/// of the screen the user actually looks at while training.
class _HeroPanel extends StatelessWidget {
  final SessionController controller;
  final double ringSize;

  const _HeroPanel({required this.controller, required this.ringSize});

  @override
  Widget build(BuildContext context) {
    final current = controller.current;
    final next = controller.next;
    final done = controller.isDone;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!done) ...[
          CountdownRing(
            timeLeft: controller.timeLeft,
            totalDuration: current!.duration,
            color: AppColors.forStep(current.type),
            label: current.label,
            formattedTime: formatClock(controller.timeLeft),
            size: ringSize,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 20,
            child: next != null
                ? Text(
                    'Ensuite : ${next.label}',
                    style: TextStyle(fontSize: 14, color: AppColors.graphite),
                  )
                : null,
          ),
        ] else ...[
          Icon(Icons.check_circle, color: AppColors.volt, size: ringSize * 0.28),
          const SizedBox(height: 12),
          const Text('Séance terminée', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
        ],
        const SizedBox(height: 20),
        SessionControls(
          isPaused: controller.isPaused,
          isDone: done,
          onToggle: controller.togglePause,
        ),
      ],
    );
  }
}

class _TimelineHeader extends StatelessWidget {
  const _TimelineHeader();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Programme',
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.graphite),
    );
  }
}

class _Timeline extends StatelessWidget {
  final SessionController controller;

  const _Timeline({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: controller.steps.length,
      itemBuilder: (_, i) => StepTile(
        step: controller.steps[i],
        isDone: i < controller.index,
        isActive: i == controller.index && !controller.isDone,
      ),
    );
  }
}
