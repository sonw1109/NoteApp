import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

// Sign up Email
  Future<User?> signUpWithEmailAndPassword(
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
      return credential.user;
    } catch (e) {
      print("Some error occured: $e");
    }
    return null;
  }

// Sign in Email
  Future<User?> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog(context, "Please enter your account");
    }
    try {
      UserCredential credential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Some error occured: $e");
    }
    return null;
  }

// Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      // GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn();
      // sign out Google account
      await googleSignIn.signOut();
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
      return userCredential.user;
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
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Ok'),
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
