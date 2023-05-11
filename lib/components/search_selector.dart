import 'package:flutter/material.dart';
import 'package:lyrics2/data/sqlite_settings_repository.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_switch/flutter_switch.dart';
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
  int searchType = SearchType.audio;
  late ThemeData currTheme;

  @override
  Widget build(BuildContext context) {
    searchType = widget.searchType;
    final manager = Provider.of<AppStateManager>(context, listen: false);
    final users = Provider.of<SQLiteSettingsRepository>(context, listen: false);
    users.init();
    final value = widget.searchType;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedToggleSwitch<int>.rolling(
          current: value,
          values: const [
            SearchType.text,
            //SearchType.songAuthor,
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
          iconBuilder: (value, _, __) {
            currTheme = users.themeData;
            switch (value) {
              case SearchType.songAuthor:
                {
                  return Icon(
                    Icons.radio,
                    color: currTheme.colorScheme.onPrimaryContainer,
                  );
                }
              case SearchType.nowPlaying:
                {
                  return Icon(
                    Icons.play_circle,
                    color: currTheme.colorScheme.onPrimaryContainer,
                  );
                }
              case SearchType.text:
              default:
                {
                  return Icon(
                    Icons.text_snippet,
                    color: currTheme.colorScheme.onPrimaryContainer,
                  );
                }
            }
          },
        ),
        //const SizedBox(height: 8),
        //Text(AppLocalizations.of(context)!.msgSearchMode),
      ],
    );
  }
}
