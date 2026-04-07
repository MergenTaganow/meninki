import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleService {
  signIn() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
    );

    print(credential.email);
    print(credential.userIdentifier);
    print(credential.familyName);
    print(credential.givenName);

    final authCredential = OAuthProvider(
      "apple.com",
    ).credential(idToken: credential.identityToken, accessToken: credential.authorizationCode);

    final userCredential = await FirebaseAuth.instance.signInWithCredential(authCredential);

    print(userCredential);
    print(userCredential.user?.email);
    print(userCredential.user?.displayName);
    print(userCredential.user?.phoneNumber);
  }
}
