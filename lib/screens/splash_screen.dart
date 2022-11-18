import 'package:flutter/material.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

class SplashScreen extends StatefulWidget {
  // SplashScreen MaterialPage Helper (15)
  static MaterialPage page() {
    return MaterialPage(
      name: LyricsPages.splashPath,
      key: ValueKey(LyricsPages.splashPath),
      child: const SplashScreen(),
    );
  }

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<AppStateManager>(context, listen: false).initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark =
        Provider.of<FirebaseUserRepository>(context, listen: false).darkMode;
    final logoImg = isDark
        ? const AssetImage('assets/lyrics_assets/splash_dark.png')
        : const AssetImage('assets/lyrics_assets/splash.png');

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              height: 300,
              image: logoImg,
            ),
            const Text("Initializing..."),
          ],
        ),
      ),
    );
  }
}
