import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/providers/firebase_auth_implementatiton/firebase_auth_services.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService extends StateNotifier<bool> {
  final Ref ref;

  SharedPreferencesService(this.ref) : super(false) {
    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    state = await prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    final firebaseAuthService = ref.read(firebaseAuthServiceProvider);
    User? user = await firebaseAuthService.signInWithEmailAndPassword(context, email, password);
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      state = true;
    }
  }

  Future<void> signInWithGoogle() async {
    final firebaseAuthService = ref.read(firebaseAuthServiceProvider);
    User? user = await firebaseAuthService.signInWithGoogle();
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      state = true;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    state = false;
  }
}

final sharePreferencesProvider = StateNotifierProvider<SharedPreferencesService, bool>(
  (ref) => SharedPreferencesService(ref),
);
