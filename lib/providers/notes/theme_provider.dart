import 'package:flutter/material.dart';
import 'package:note_app/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(lightTheme);

  void changeTheme() {
    if (state == lightTheme) {
      state = darkTheme;
    } else {
      state = lightTheme;
    }
  }
}

final changeThemeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>(
  (ref) {
    return ThemeNotifier();
  },
);
