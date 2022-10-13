import 'package:flutter/material.dart';
import 'package:lyrics_2/screens/screens.dart';
import 'package:lyrics_2/models/models.dart';
import 'package:lyrics_2/components/lyric_detail_screen.dart';
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

  static List<Widget> pages = <Widget>[
    EmptyFavoritesScreen(),
    SearchScreen(),
    LyricDetailScreen(
      lyric: Lyric(
        id: 1,
        title: "The Musical Box",
        author: "Genesis",
        imageUrl: "assets/B00104WHLA.02.MZZZZZZZ.jpg",
        lyric: """Play me "Old King Cole"
that I may join with you,
all your hearts now seem so far from me
it hardly seems to matter now.

And the nurse will tell you lies
of a Kingdom beyond the skies.
But I'm lost within this half-world,
it hardly seems to matter now.

Play me my song,
here it comes again.
Play me my song,
here it comes again.

Just a little bit,
just a little bit more time,
time left to live out my life.

Play me my song,
here it comes again.
Play me my song,
here it comes again.

Old King Cole was a merry old soul,
and a merry old soul was he.
So he called for his pipe,
and he called for his bowl,
and he called for his fiddlers three.

And the clock, tick tock,
on the mantlepiece,
and I want,
and I feel,
and I know,
and I touch the wall.

She's a lady, she's got time.
Brush back you hair, and let me get to know your face.
She's a lady, she's mine.
Brush back you hair, and let me get to know your flesh.

I've been waiting here so long
and all this time has passed me by.
It doesn't seem to matter now.
You stand there with your fixed expression
casting doubt on all I have to say.
Why don't you touch me, touch me?
Why don't you touch me, touch me?
Touch me now, now now, now, now ...

The musical box:
While Henry Hamilton-Smythe minor (8) was playing croquet with Cynthia Jane De Blaise-William (9), sweet smiling Cynthia
raised her mallet high and gracefully removed Henry's head. Two weeks later, in Henry's nursery, she discovered his treasured
musical box. Eagerly she opened it and as "Old King Cole" began to play, a small spirit-figure appeared. Henry had returned -
but not for long, for as he stood in the room his body began ageing rapidly, leaving a child's mind inside. A lifetime's desires
surged through him. Unfortunately the attempt to persuade Cynthia Jane to fulfill his romantic desire led his nurse to the
nursery to investigate the noise. Instinctively she hurled the musical box at the bearded child, destroying both.
        """,
      ),
    ), //Container(color: Colors.green),
  ];
}
