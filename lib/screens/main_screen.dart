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

  const MainScreen({super.key, required this.currentTab});

  final int currentTab;

  @override
  State<MainScreen> createState() => _MainScreenState();
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
      builder: (context, manager, child) {
        final users =
            Provider.of<FirebaseUserRepository>(context, listen: false);
        String pageTitle = "";

        if (widget.currentTab == 0) {
          pageTitle =
              "${AppLocalizations.of(context)!.appName} - ${AppLocalizations.of(context)!.msgFavorites}";
        } else if (widget.currentTab == 2) {
          pageTitle = "${AppLocalizations.of(context)!.appName} - Info";
        } else {
          pageTitle = AppLocalizations.of(context)!.appName;
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: users.themeData.colorScheme.primaryContainer,
            title: Text(pageTitle),
            titleTextStyle: Theme.of(context).textTheme.displayLarge,
            actions: [
              profileButton(widget.currentTab),
            ],
          ),
          // Select which tab is to be shown
          body: pages[widget.currentTab],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: users.themeData.colorScheme.primaryContainer,
            unselectedItemColor: users.themeData.colorScheme.onSurfaceVariant.withValues(red:0.6, green: 0.6, blue: 0.6),
            currentIndex: widget.currentTab,
            onTap: (index) {
              //only redraw if we are not already in that tab
              if (index !=
                  Provider.of<AppStateManager>(context, listen: false)
                      .getSelectedTab) {
                Provider.of<AppStateManager>(context, listen: false)
                    .goToTab(index);
              }
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Provider.of<AppStateManager>(context, listen: false)
                    .icnFavorite),
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
