 import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthController {
  static const List<String> scopes = <String>[
    'email',
  ];

  Future<void> signOut() async {
    // TODO: Implement removing token from local storage
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    // TODO: Implement getting current user information
    return null;
  }

  Future<UserCredential?> signIn() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: scopes).signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }
}