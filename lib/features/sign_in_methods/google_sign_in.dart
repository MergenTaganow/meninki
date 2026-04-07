import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleService {
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  Future<void> signIn() async {
    await googleSignIn.initialize(
      clientId: "86845493759-415he26gbld98oq427mp1rhk774kioja.apps.googleusercontent.com",
      serverClientId: "86845493759-mds6qgjj8roahh03q5dnvanfttvv7484.apps.googleusercontent.com",
    );

    GoogleSignInAccount googleUser = await googleSignIn.authenticate();

    final idToken = googleUser.authentication.idToken;
    final authorizationClient = googleUser.authorizationClient;
    GoogleSignInClientAuthorization? authorization = await authorizationClient
        .authorizationForScopes(['email', 'profile']);
    final accessToken = authorization?.accessToken;
    if (accessToken != null) {
      final authCredential2 = await authorizationClient.authorizationForScopes([
        'email',
        'profile',
      ]);

      if (authCredential2?.accessToken == null) {
        throw FirebaseAuthException(code: "error", message: "error");
      }
    }

    final credential = GoogleAuthProvider.credential(accessToken: accessToken, idToken: idToken);

    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );

    print(userCredential);
    print(userCredential.user?.email);
    print(userCredential.user?.displayName);
    print(userCredential.user?.phoneNumber);
  }
}
