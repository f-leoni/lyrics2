import 'package:flutter/material.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter_switch/flutter_switch.dart';

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
    final users = Provider.of<FirebaseUserRepository>(context, listen: false);
    final value = widget.searchType == SearchType.text ? true : false;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlutterSwitch(
            value: value,
            height: 40.0,
            width: 80,
            onToggle: (bool newSearchType) {
              //if changed. True = text, false = audio
              if (newSearchType && widget.searchType == SearchType.audio) {
                searchType = SearchType.text;
                manager.switchSearch(
                    context,
                    widget.searchControllerText.text,
                    widget.searchControllerAuthor.text,
                    widget.searchControllerSong.text);
              } else if (!newSearchType &&
                  widget.searchType == SearchType.text) {
                searchType = SearchType.audio;
                manager.switchSearch(
                    context,
                    widget.searchControllerText.text,
                    widget.searchControllerAuthor.text,
                    widget.searchControllerSong.text);
              }
            },
            activeIcon: Icon(
              Icons.text_snippet,
              color: users.themeData.colorScheme.secondary,
            ),
            activeColor: users.themeData.indicatorColor,
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
            ),
          ),
          //const SizedBox(height: 8),
          //Text(AppLocalizations.of(context)!.msgSearchMode),
        ],
      ),
    );
  }
}
