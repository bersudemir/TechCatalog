import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _usernameKey = 'ls_username';

  Future<void> saveData(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(_usernameKey, username);
    debugPrint('Saved username: $username');
  }

  Future<String?> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_usernameKey);
  }

  Future<void> clearData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove(_usernameKey);
  }
}
