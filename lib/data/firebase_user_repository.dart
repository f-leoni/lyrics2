import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lyrics2/components/logger.dart';

class FirebaseUserRepository with ChangeNotifier {
  final auth = FirebaseAuth.instance;
  String _lastError = "";
  bool get didSelectUser => _didSelectUser;
  bool get darkMode => _darkMode;
  bool get useGenius => _useGenius;
  set darkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  set useGenius(bool value) {
    _useGenius = value;
    notifyListeners();
  }

  User? get getUser => auth.currentUser;
  var _didSelectUser = false;
  var _darkMode = true;
  var _useGenius = false;

  ImageProvider<Object> get userImage {
    if ((auth.currentUser != null) & (auth.currentUser!.photoURL == null)) {
      return const AssetImage('assets/icon.png');
    } else {
      return NetworkImage(auth.currentUser!.photoURL!);
    }
  }

  String get lastError => _lastError;

  Future<bool> login(String email, String password) async {
    _lastError = "";
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _lastError = e.message!;
      logger.e('Error during authentication: ${e.message}.');
      rethrow;
    } catch (e) {
      _lastError = e.toString();
      logger.e("Error during login: $e");
      rethrow;
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

  Future<bool> signup(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _lastError = e.message!;
      logger.e('Error during user registration: ${e.message}.');
      return false;
    } catch (e) {
      _lastError = e.toString();
      logger.e("Error during signup: $e");
      return false;
    }
  }

  void tapOnProfile(bool selected) {
    logger.d("Setting didSelectUser as ${selected.toString()}");
    _didSelectUser = selected;
    notifyListeners();
  }

  void logout() async {
    await auth.signOut();
    notifyListeners();
  }
}
