import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:lyrics2/models/models.dart';

class OnboardingScreen extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: LyricsPages.onboardingPath,
      key: ValueKey(LyricsPages.onboardingPath),
      child: const OnboardingScreen(),
    );
  }

  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  final Color rwColor = const Color.fromRGBO(64, 143, 77, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(AppLocalizations.of(context)!.gettingStarted,
            style: Provider.of<FirebaseUserRepository>(context, listen: false)
                .textTheme
                .headline1),
        leading: GestureDetector(
          child: Icon(
            Icons.chevron_left,
            size: 35,
            color: Provider.of<FirebaseUserRepository>(context, listen: false)
                .themeData
                .primaryColorDark,
          ),
          onTap: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: buildPages()),
            buildIndicator(),
            buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MaterialButton(
          child: const Text('Skip'),
          onPressed: () {
            // Onboarding -> Navigate to home
            Provider.of<AppStateManager>(context, listen: false)
                .completeOnboarding(context);
          },
        ),
      ],
    );
  }

  Widget buildPages() {
    return PageView(
      controller: controller,
      children: [
        onboardPageView(
          const AssetImage('assets/lyrics_assets/search_b.png'),
          AppLocalizations.of(context)!.onboardingSearch,
        ),
        onboardPageView(
          const AssetImage('assets/lyrics_assets/favorite.png'),
          AppLocalizations.of(context)!.onboardingAdd,
        ),
        onboardPageView(
          const AssetImage('assets/lyrics_assets/singer.png'),
          AppLocalizations.of(context)!.onboardingCome,
        ),
      ],
    );
  }

  Widget onboardPageView(ImageProvider imageProvider, String text) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image(
              fit: BoxFit.fitWidth,
              image: imageProvider,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: Provider.of<FirebaseUserRepository>(context, listen: false)
                .textTheme
                .headline1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget buildIndicator() {
    return SmoothPageIndicator(
      controller: controller,
      count: 3,
      effect: WormEffect(
        activeDotColor: rwColor,
      ),
    );
  }
}
