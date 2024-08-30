import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

// Sign up Email
  Future<String?> signUpWithEmailAndPassword(
      BuildContext context, String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      _showErrorDialog(context, "Password do not match");
    }
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showErrorDialog(context, "Please enter your account");
    }
    try {
      UserCredential credential =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user?.uid;
    } catch (e) {
      print("Some error occured: $e");
    }
    return null;
  }

// Sign in Email
  Future<String?> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog(context, "Please enter your account");
    }
    try {
      UserCredential credential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        _showErrorDialog(context, 'email invalid');
      }
    }
    // } catch (e) {
    //   _showErrorDialog(context, "Some error occured: $e");
    // }
    return null;
  }

// Sign in with Google
  Future<String?> signInWithGoogle() async {
    try {
      // GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn();
      // sign out Google account
      await googleSignIn.signOut();

      // Add a small delay to ensure sign out is complete
      await Future.delayed(Duration(seconds: 1));

      // begin interactive sign in process
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

      // obtain auth details from request
      final GoogleSignInAuthentication? googleAuth = await googleSignInAccount?.authentication;
      // create a new credential for user
      final credentialUser = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // finally, sign in
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credentialUser);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      return userCredential.user?.uid;
      // return FirebaseAuth.instance.currentUser;
    } catch (e) {
      print("Some error occured: $e");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}

// Provider cho FirebaseAuthService
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});
