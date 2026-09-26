import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
// f
void main() {
  runApp(const ChronoApp());
}

class ChronoApp extends StatefulWidget {
  const ChronoApp({super.key});
  @override
  State<ChronoApp> createState() => _ChronoAppState();
}

class _ChronoAppState extends State<ChronoApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chrono Coach',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: TimerSetupPage(
        currentThemeMode: _themeMode,
        onThemeChanged: (mode) => setState(() => _themeMode = mode),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<File> getLocalFile() async {
  final dir = Directory.systemTemp;
  return File('${dir.path}/chrono_config.json');
}

Future<Map<String, dynamic>?> readConfig() async {
  try {
    final file = await getLocalFile();
    if (!file.existsSync()) return null;
    final contents = await file.readAsString();
    return jsonDecode(contents);
  } catch (_) {
    return null;
  }
}

Future<void> saveConfig(int nb, int duree, int pause, int grandePause) async {
  final file = await getLocalFile();
  final data = {
    'nb': nb,
    'duree': duree,
    'pause': pause,
    'grandePause': grandePause,
  };
  await file.writeAsString(jsonEncode(data));
}
class TimerSetupPage extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final void Function(ThemeMode) onThemeChanged;

  const TimerSetupPage({
    super.key,
    required this.currentThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<TimerSetupPage> createState() => _TimerSetupPageState();
}

class _TimerSetupPageState extends State<TimerSetupPage> {
  final _nbC = TextEditingController();
  final _dureeC = TextEditingController();
  final _pauseC = TextEditingController();
  final _grandePauseC = TextEditingController();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    readConfig().then((data) {
      if (data != null) {
        _nbC.text = data['nb'].toString();
        _dureeC.text = data['duree'].toString();
        _pauseC.text = data['pause'].toString();
        _grandePauseC.text = data['grandePause'].toString();
      }
      setState(() => _loaded = true);
    });
  }

  void launch() {
    final nb = int.tryParse(_nbC.text) ?? 0;
    final duree = int.tryParse(_dureeC.text) ?? 0;
    final pause = int.tryParse(_pauseC.text) ?? 0;
    final grandePause = int.tryParse(_grandePauseC.text) ?? 0;
    if (nb > 0 && duree > 0 && pause >= 0 && grandePause >= 0) {
      saveConfig(nb, duree, pause, grandePause);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TimerPage(
            nbSeances: nb,
            dureeSeance: duree,
            pause: pause,
            grandePause: grandePause,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Remplis correctement tous les champs")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuration du chrono"),
        actions: [
          PopupMenuButton<ThemeMode>(
            icon: const Icon(Icons.color_lens),
            onSelected: widget.onThemeChanged,
            initialValue: widget.currentThemeMode,
            itemBuilder: (_) => [
              const PopupMenuItem(value: ThemeMode.light, child: Text("Clair")),
              const PopupMenuItem(value: ThemeMode.dark, child: Text("Sombre")),
              const PopupMenuItem(value: ThemeMode.system, child: Text("Système")),
            ],
          )
        ],
      ),
      body: _loaded
          ? ListView(padding: const EdgeInsets.all(16), children: [
              _buildInput("Nombre séances", _nbC, ""),
              _buildInput("Durée séance", _dureeC, "sec"),
              _buildInput("Pause", _pauseC, "sec"),
              _buildInput("Grande pause", _grandePauseC, "sec"),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text("Lancer", style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(60)),
                onPressed: launch,
              ),
            ])
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildInput(String label, TextEditingController c, String suffix) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.timer),
        title: TextField(
          controller: c,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: label, suffixText: suffix),
        ),
      ),
    );
  }
}

class TimerPage extends StatefulWidget {
  final int nbSeances, dureeSeance, pause, grandePause;

  const TimerPage({
    super.key,
    required this.nbSeances,
    required this.dureeSeance,
    required this.pause,
    required this.grandePause,
  });

  @override
  State<TimerPage> createState() => _TimerPageState();
}

enum StepType { seance, pause, grandePause }

class _Step {
  final String label;
  final int duration;
  final StepType type;
  _Step(this.label, this.duration, this.type);
}

class _TimerPageState extends State<TimerPage> {
  late List<_Step> _steps;
  int _idx = 0, _timeLeft = 0;
  bool _isPaused = false;
  Timer? _timer;
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _generateSteps();
    _start();
  }

  void _generateSteps() {
    _steps = [];
    for (int i = 0; i < widget.nbSeances; i++) {
      _steps.add(_Step('Séance ${i + 1}', widget.dureeSeance, StepType.seance));
      if (i < widget.nbSeances - 1) {
        _steps.add(_Step('Pause ${i + 1}', widget.pause, StepType.pause));
      }
    }
    _steps.add(_Step('Grande pause', widget.grandePause, StepType.grandePause));
  }

  void _start() {
    if (_idx >= _steps.length) return;
    setState(() {
      _timeLeft = _steps[_idx].duration;
      _isPaused = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isPaused) _tick();
    });
  }

  void _tick() {
    setState(() {
      _timeLeft--;

      if (_timeLeft <= 5 && _timeLeft > 0) {
        _player.play(AssetSource("sounds/beep.mp3"));
      }

      if (_timeLeft == 0) {
        _player.play(AssetSource("sounds/final_beep.mp3"));
        _timer?.cancel();
        _idx++;
        if (_idx < _steps.length) _start();
      }
    });
  }

  void _togglePause() {
    setState(() => _isPaused = !_isPaused);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    super.dispose();
  }

  Color _color(StepType t) => {
        StepType.seance: Colors.green,
        StepType.pause: Colors.orange,
        StepType.grandePause: Colors.blue,
      }[t]!;

  String _fmt(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$m:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final done = _idx >= _steps.length;
    final current = done ? null : _steps[_idx];
    final next = (!done && _idx + 1 < _steps.length) ? _steps[_idx + 1] : null;

    return Scaffold(
      appBar: AppBar(title: const Text("Chrono")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          if (!done) ...[
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: _color(current!.type),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(_fmt(_timeLeft),
                  style: const TextStyle(fontSize: 40, color: Colors.white)),
            ),
            const SizedBox(height: 10),
            Text(current.label, style: const TextStyle(fontSize: 24)),
            if (next != null)
              Text('Ensuite : ${next.label}',
                  style: const TextStyle(fontSize: 18, color: Colors.grey)),
          ] else ...[
            const Text('✅ Terminé', style: TextStyle(fontSize: 24)),
          ],
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            label: Text(_isPaused ? 'Reprendre' : 'Pause'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(150, 50)),
            onPressed: done ? null : _togglePause,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _steps.length,
              itemBuilder: (_, i) {
                final s = _steps[i];
                final d = i < _idx;
                final a = i == _idx;
                return ListTile(
                  leading: Icon(
                    d
                        ? Icons.check_circle
                        : a
                            ? Icons.play_circle
                            : Icons.circle_outlined,
                    color: d
                        ? Colors.green
                        : a
                            ? _color(s.type)
                            : Colors.grey,
                  ),
                  title: Text(s.label),
                  trailing: Text('${s.duration}s'),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
