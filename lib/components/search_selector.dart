import 'package:flutter/material.dart';
import 'package:lyrics2/data/sqlite_settings_repository.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:provider/provider.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class SearchSelector extends StatefulWidget {
  final int searchType;
  final TextEditingController searchControllerText;
  final TextEditingController searchControllerAuthor;
  final TextEditingController searchControllerSong;

  const SearchSelector({
    Key? key,
    required this.searchType,
    required this.searchControllerText,
    required this.searchControllerAuthor,
    required this.searchControllerSong,
  }) : super(key: key);

  @override
  State<SearchSelector> createState() => _SearchSelectorState();
}

class _SearchSelectorState extends State<SearchSelector> {
  int searchType = 0;

  @override
  Widget build(BuildContext context) {
    searchType = widget.searchType;
    final manager = Provider.of<AppStateManager>(context, listen: false);
    final settings = Provider.of<SQLiteSettingsRepository>(context, listen: false);
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
          onChanged: (int newSearchType) {
            searchType = newSearchType;
            manager.switchSearch(
                context,
                newSearchType,
                widget.searchControllerText.text,
                widget.searchControllerAuthor.text,
                widget.searchControllerSong.text);
          },
          iconBuilder: (value, _ , __) {
            switch (value) {
              case SearchType.audio:
                {
                  return Icon(
                    Icons.radio,
                    color: settings.themeData.colorScheme.background,);
                }
              case SearchType.nowPlaying:
                {
                  return Icon(
                    Icons.play_circle,
                    color: settings.themeData.colorScheme.background,);
                }
              case SearchType.text:
              default:
                {
                  return Icon(
                    Icons.text_snippet,
                    color: settings.themeData.colorScheme.background,);
                }
            }
          },
          /*activeColor: users.themeData.indicatorColor,
          activeToggleColor: users.themeData.primaryColor,
          activeSwitchBorder: Border.all(
            color: users.themeData.colorScheme.secondary,
            width: 4.0,
          ),
          inactiveIcon: Icon(
            Icons.radio,
            color: users.themeData.colorScheme.secondary,
          ),
          inactiveColor: users.themeData.indicatorColor,
          inactiveToggleColor: users.themeData.primaryColor,
          inactiveSwitchBorder: Border.all(
            color: users.themeData.colorScheme.secondary,
            width: 4.0,
          ),*/
        ),
        //const SizedBox(height: 8),
        //Text(AppLocalizations.of(context)!.msgSearchMode),
      ],
    );
  }
}
