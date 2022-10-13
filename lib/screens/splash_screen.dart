import 'package:flutter/material.dart';
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
    // Initialize App (16)
    Provider.of<AppStateManager>(context, listen: false).initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              height: 200,
              image: AssetImage('assets/lyrics_assets/logo.png'),
            ),
            const Text('Initializing...'),
          ],
        ),
      ),
    );
  }
}
