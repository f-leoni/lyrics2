import 'package:flutter/material.dart';
import 'package:lyrics_2/screens/screens.dart';
import 'package:lyrics_2/models/models.dart';
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
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = <Widget>[
      const EmptyFavoritesScreen(),
      const SearchScreen(),
      LyricDetailScreen(
        lyric: Provider.of<AppStateManager>(context, listen: false).lyric,
      ), //Container(color: Colors.green),
    ];

    return Consumer<AppStateManager>(
      builder: (context, appStateManager, child) {
        return Scaffold(
          appBar: AppBar(
            title:
                Text('Lyrics 2', style: Theme.of(context).textTheme.headline6),
          ),
          // Select which tab is to be shown
          body: pages[widget.currentTab],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor:
                Theme.of(context).textSelectionTheme.selectionColor,
            // 3
            currentIndex: widget.currentTab,
            onTap: (index) {
              // 4
              Provider.of<AppStateManager>(context, listen: false)
                  .goToTab(index);
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.find_in_page),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info),
                label: 'Info',
              ),
            ],
          ),
        );
      },
    );
  }

  void _search() {
    setState(() {
      _isSearching = !_isSearching;
    });
    //Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchPage()));
    print("Ciao " + _isSearching.toString());
  }
}
