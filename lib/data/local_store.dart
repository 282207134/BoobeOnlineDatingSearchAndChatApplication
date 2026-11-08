import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// A single versioned record keeps demo data small and easy to reset.
class LocalStore {
  late final SharedPreferencesAsync _preferences = SharedPreferencesAsync();
  Future<Map<String, dynamic>> read() async {
    final raw = await _preferences.getString('boobe.v1');
    if (raw == null) return {};
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } on FormatException {
      return {};
    }
  }

  Future<void> write(Map<String, dynamic> value) =>
      _preferences.setString('boobe.v1', jsonEncode(value));
}
