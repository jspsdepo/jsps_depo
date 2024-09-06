import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends GetxService {
  final _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  Future<void> loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isDarkTheme = prefs.getBool('isDarkTheme');
    if (isDarkTheme == null) {
      _themeMode.value = ThemeMode.system;
    } else {
      _themeMode.value = isDarkTheme ? ThemeMode.dark : ThemeMode.light;
    }
  }

  Future<void> toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_themeMode.value == ThemeMode.light) {
      _themeMode.value = ThemeMode.dark;
      await prefs.setBool('isDarkTheme', true);
    } else if (_themeMode.value == ThemeMode.dark) {
      _themeMode.value = ThemeMode.light;
      await prefs.setBool('isDarkTheme', false);
    } else {
      // Handle the case where the theme is system and toggle to a default (e.g., light)
      _themeMode.value = ThemeMode.light;
      await prefs.setBool('isDarkTheme', false);
    }
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeMode.value = themeMode;
    if (themeMode == ThemeMode.light) {
      await prefs.setBool('isDarkTheme', false);
    } else if (themeMode == ThemeMode.dark) {
      await prefs.setBool('isDarkTheme', true);
    }
  }
}
