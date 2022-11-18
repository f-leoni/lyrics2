import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lyrics2/components/logger.dart';
import 'package:lyrics2/lyricstheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FirebaseUserRepository with ChangeNotifier {
  final auth = FirebaseAuth.instance;
  String _lastErrorMsg = "";
  String _lastErrorCode = "";

  bool get didSelectUser => _didSelectUser;
  bool get darkMode => _darkMode;
  bool get useGenius => _useGenius;
  String get lastErrorMsg => _lastErrorMsg;
  String get lastErrorCode => _lastErrorCode;

  set darkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  set useGenius(bool value) {
    _useGenius = value;
    notifyListeners();
  }

  ThemeData get themeData {
    if (_darkMode) return LyricsTheme.dark();
    return LyricsTheme.light();
  }

  TextTheme get textTheme {
    if (_darkMode) return LyricsTheme.darkTextTheme;
    return LyricsTheme.lightTextTheme;
  }

  User? get getUser => auth.currentUser;
  var _didSelectUser = false;
  var _darkMode = false;
  var _useGenius = false;

  ImageProvider<Object> get userImage {
    if ((auth.currentUser != null) & (auth.currentUser!.photoURL == null)) {
      return const AssetImage('assets/icon.png');
    } else {
      return NetworkImage(auth.currentUser!.photoURL!);
    }
  }

  Future<UserCredential?> login(String email, String password) async {
    _lastErrorMsg = "";
    UserCredential? uc;
    try {
      uc = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return uc;
    } on FirebaseAuthException catch (e) {
      _lastErrorMsg = e.message!;
      _lastErrorCode = e.code;
      logger.e('Error during authentication: ${e.message}.');
      return uc;
    } catch (e) {
      _lastErrorMsg = e.toString();
      _lastErrorCode = "000";
      logger.e("Error during login: $e");
      return uc;
    }
  }

  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  String? userId() {
    return auth.currentUser?.uid;
  }

  String? email() {
    return auth.currentUser?.email;
  }

  Future<UserCredential?> signup(String email, String password) async {
    UserCredential? uc;
    try {
      uc = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return uc;
    } on FirebaseAuthException catch (e) {
      _lastErrorMsg = e.message!;
      _lastErrorCode = e.code;
      logger.e('Error during user registration: ${e.message}.');
      return uc;
    } catch (e) {
      _lastErrorMsg = e.toString();
      _lastErrorCode = "000";
      logger.e("Error during signup: $e");
      return uc;
    }
  }

  void tapOnProfile(bool selected) {
    logger.d("Setting didSelectUser as ${selected.toString()}");
    _didSelectUser = selected;
    notifyListeners();
  }

  void logout() async {
    _darkMode = false;
    _useGenius = false;
    await auth.signOut();
    notifyListeners();
  }

  String codeToLocalizedString(AppLocalizations loc, String code) {
    switch (code) {
      case "wrong-password":
        {
          return loc.errWrongPwd;
        }
      case "invalid-email":
        {
          return loc.errInvalidEmail;
        }
      case "user-disabled":
        {
          return loc.errUserDisabled;
        }
      case "user-not-found":
        {
          return loc.errUserNotFound;
        }
      case "email-already-in-use":
        {
          return loc.errEmailAlreadyInUse;
        }
      case "operation-not-allowed":
        {
          return loc.errOperationNotAllowed;
        }
      case "weak-password":
        {
          return loc.errWeakPassword;
        }

      default:
        {
          return code;
        }
    }
  }
}
