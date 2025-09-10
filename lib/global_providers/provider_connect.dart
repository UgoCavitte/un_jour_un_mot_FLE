import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:un_jour_un_mot/composants/my_flush_bars.dart';
import 'package:un_jour_un_mot/data/init_firebase.dart';

// Géré par la connexion à Firebase
class ProviderConnect with ChangeNotifier {
  // bool isUserConnected = false;

  bool get isUserConnected => Login.isUserConnected;
  bool get isUserConnecting => Login.isUserConnecting;
  User? get currentUser => FirebaseAuth.instance.currentUser;

  Future<void> connectUser() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      signInOption: SignInOption.standard,
    );

    try {
      var googleSignInAccount = await googleSignIn.signIn();

      Login.isUserConnecting = true;
      notifyListeners();

      final googleAuth = await googleSignInAccount?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (kIsWeb) {
        FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      }

      if (googleSignInAccount != null) {
        Login.isUserConnecting = false;
        Login.isUserConnected = true;
        await InitFirebase.getUserData();
      }

      notifyListeners();
    } catch (error) {
      Login.isUserConnecting = false;
      MyFlushBar(
        message: FlushBarMessage.erreurDeConnexion,
        complement: error.toString(),
        typeMessage: FlushBarTypeMessage.rouge,
      ).show();
      debugPrintStack(label: "[app] $error");
    }
  }
}

abstract class Login {
  static bool isUserConnected = false;
  static bool isUserConnecting = false;

  static Future<void> autoConnect() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      isUserConnecting = false;
      isUserConnected = true;
      await InitFirebase.getUserData();
    }
  }
}
