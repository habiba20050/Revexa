import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:revexa/core/constants/app_constants.dart';

class GoogleSignInService {
  GoogleSignInService._();

  static GoogleSignIn get _instance => GoogleSignIn(
        scopes: const ['email', 'profile'],
        clientId: kIsWeb ? AppConstants.googleWebClientId : null,
      );

  static Future<String?> signInAndGetIdToken() async {
    final account = await _instance.signIn();
    if (account == null) return null;

    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw Exception(
        kIsWeb
            ? 'Google Sign-In on web failed to return ID token'
            : 'Google did not return an ID token',
      );
    }
    return idToken;
  }
}
