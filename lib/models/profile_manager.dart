import 'package:flutter/material.dart';

import 'models.dart';

class ProfileManager extends ChangeNotifier {
  MyUser get getUser => MyUser(
        firstName: 'Stef',
        lastName: 'Patt',
        role: 'Flutterista!',
        email: 'fraleoni@gmail.com',
        profileImageUrl: 'assets/profile_pics/person_stef.jpeg',
        points: 100,
        darkMode: _darkMode,
        useGenius: _useGenius,
      );

  bool get didSelectUser => _didSelectUser;
  bool get darkMode => _darkMode;

  var _didSelectUser = false;
  var _darkMode = true;
  var _useGenius = false;

  set darkMode(bool darkMode) {
    _darkMode = darkMode;
    notifyListeners();
  }

  set useGenius(bool useGenius) {
    _useGenius = useGenius;
    notifyListeners();
  }

  void tapOnProfile(bool selected) {
    _didSelectUser = selected;
    notifyListeners();
  }
}
