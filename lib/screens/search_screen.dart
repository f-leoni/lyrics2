import 'package:flutter/material.dart';
import 'package:lyrics_2/lyricstheme.dart';
import 'package:lyrics_2/models/models.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: LyricsPages.loginPath,
      key: ValueKey(LyricsPages.loginPath),
      child: const SearchScreen(),
    );
  }

  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // The search area here
          title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    /* Clear the search field */
                  },
                ),
                hintText: 'Search...',
                border: InputBorder.none),
            onEditingComplete: () =>
                Provider.of<AppStateManager>(context, listen: false).goToTab(2),
          ),
        ),
      )),
    );
  }
}
