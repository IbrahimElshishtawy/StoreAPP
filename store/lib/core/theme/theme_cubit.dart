import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences sharedPreferences;
  static const String _themeKey = 'theme_mode';

  ThemeCubit(this.sharedPreferences) : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() {
    final themeIndex = sharedPreferences.getInt(_themeKey) ?? 0;
    emit(ThemeMode.values[themeIndex]);
  }

  void toggleTheme() {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    sharedPreferences.setInt(_themeKey, newMode.index);
    emit(newMode);
  }
}
