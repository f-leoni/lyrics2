import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics2/components/circle_image.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:lyrics2/screens/info_screen.dart';
import 'package:lyrics2/screens/screens.dart';
import 'package:lyrics2/models/models.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static MaterialPage page(int currentTab) {
    return MaterialPage(
      name: LyricsPages.home,
      key: ValueKey(LyricsPages.home),
      child: MainScreen(
        currentTab: currentTab,
      ),
    );
  }

  const MainScreen({Key? key, required this.currentTab}) : super(key: key);

  final int currentTab;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = <Widget>[
      const FavoritesScreen(),
      const SearchScreen(),
      const InfoScreen(),
    ];
    return Consumer<AppStateManager>(
      builder: (context, appStateManager, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.appName,
                style: Theme.of(context).textTheme.headline6),
            actions: [
              profileButton(widget.currentTab),
            ],
          ),
          // Select which tab is to be shown
          body: pages[widget.currentTab],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Theme.of(context).indicatorColor,
            currentIndex: widget.currentTab,
            onTap: (index) {
              Provider.of<AppStateManager>(context, listen: false)
                  .goToTab(index);
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite),
                label: AppLocalizations.of(context)!.lblFavs,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.find_in_page),
                label: AppLocalizations.of(context)!.lblSearch,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.info),
                label: AppLocalizations.of(context)!.lblInfo,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget profileButton(int currentTab) {
    //var manager = Provider.of<AppStateManager>(context, listen: false);
    var users = Provider.of<FirebaseUserRepository>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        child: CircleImage(
          imageProvider:
              Provider.of<FirebaseUserRepository>(context, listen: false)
                  .userImage,
        ),
        onTap: () {
          users.tapOnProfile(true);
        },
      ),
    );
  }
}
