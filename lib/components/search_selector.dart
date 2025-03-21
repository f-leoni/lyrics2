import 'package:flutter/material.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:provider/provider.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class SearchSelector extends StatefulWidget {
  final int searchType;
  final TextEditingController searchControllerText;
  final TextEditingController searchControllerAuthor;
  final TextEditingController searchControllerSong;

  const SearchSelector({
    super.key,
    required this.searchType,
    required this.searchControllerText,
    required this.searchControllerAuthor,
    required this.searchControllerSong,
  });

  @override
  State<SearchSelector> createState() => _SearchSelectorState();
}

class _SearchSelectorState extends State<SearchSelector> {
  int searchType = 0;

  @override
  Widget build(BuildContext context) {
    searchType = widget.searchType;
    final manager = Provider.of<AppStateManager>(context, listen: false);
    final users = Provider.of<FirebaseUserRepository>(context, listen: false);
    final int value = widget.searchType;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedToggleSwitch<int>.rolling(
          current: value,
          values: const [
            SearchType.text,
            SearchType.audio,
            SearchType.nowPlaying,
          ],
          height: 40.0,
          innerColor: users.themeData.primaryColorLight,
          borderColor: users.themeData.canvasColor,
          indicatorColor: users.themeData.indicatorColor,
          onChanged: (int newSearchType) {
            searchType = newSearchType;
            manager.switchSearch(
                context,
                newSearchType,
                widget.searchControllerText.text,
                widget.searchControllerAuthor.text,
                widget.searchControllerSong.text
            );
          },
          iconBuilder: (value, _ , __) {
            switch (value) {
              case SearchType.audio:
                {
                  return Icon(
                    Icons.radio,
                    color: users.themeData.canvasColor,);
                }
              case SearchType.nowPlaying:
                {
                  return Icon(
                    Icons.play_circle,
                    color: users.themeData.canvasColor,);
                }
              case SearchType.text:
              default:
                {
                  return Icon(
                    Icons.text_snippet,
                    color: users.themeData.canvasColor,);
                }
            }
          },
        ),
      ],
    );
  }
}
