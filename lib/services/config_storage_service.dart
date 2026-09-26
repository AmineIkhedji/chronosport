import 'dart:convert';
import 'dart:io';

import '../models/session_config.dart';

/// Reads and writes the last-used [SessionConfig] to a small JSON file
/// on disk, so the setup screen can remember the user's last values.
class ConfigStorageService {
  const ConfigStorageService();

  Future<File> _file() async {
    final dir = Directory.systemTemp;
    return File('${dir.path}/chrono_config.json');
  }

  Future<SessionConfig?> read() async {
    try {
      final file = await _file();
      if (!file.existsSync()) return null;
      final contents = await file.readAsString();
      return SessionConfig.fromJson(jsonDecode(contents));
    } catch (_) {
      return null;
    }
  }

  Future<void> save(SessionConfig config) async {
    final file = await _file();
    await file.writeAsString(jsonEncode(config.toJson()));
  }
}
