import 'package:flutter/material.dart';
import 'package:lyrics2/data/sqlite_settings_repository.dart';
import 'package:provider/provider.dart';
import 'package:lyrics2/components/circle_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics2/models/models.dart';

import '../components/proxy_selector.dart';

class ProfileScreen extends StatefulWidget {
  // ProfileScreen MaterialPage Helper
  static MaterialPage page() {
    return MaterialPage(
      name: LyricsPages.profilePath,
      key: ValueKey(LyricsPages.profilePath),
      child: const ProfileScreen(),
    );
  }

  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //static const List<String> services = <String>['Genius', 'ChartLyrics'];
  @override
  Widget build(BuildContext context) {
    var users = Provider.of<SQLiteSettingsRepository>(context, listen: false);
    //users.init();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: users.themeData.colorScheme.primaryContainer,
        leading: IconButton(
          icon: Icon(Icons.close,
              size: 30, color: users.themeData.highlightColor),
          onPressed: () {
            // Close Profile Screen
            users.tapOnProfile(false);
          },
        ),
        title: Text(AppLocalizations.of(context)!.ttlProfile,
            style: users.themeData.textTheme.displayMedium),
      ),
      body: Container(
        color: users.themeData.primaryColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16.0),
                buildProfile(),
                Expanded(
                  child: buildMenu(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenu() {
    return ListView(
      children: [
        buildDarkModeRow(),
        buildBackgroundRow(),
        buildProxyRow(),
      ],
    );
  }

  Widget buildProfile() {
    //final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final users = Provider.of<SQLiteSettingsRepository>(context, listen: false);
    //users.init();
    return Column(
      children: [
        const CircleImage(
          imageProvider: AssetImage('assets/lyrics_assets/logo.png'),
          imageRadius: 60.0,
        ),
        const SizedBox(height: 8.0),
        Text(AppLocalizations.of(context)!.msgLocalUser,
            style: users.themeData.textTheme.displayLarge),
        const Text(""), //role
      ],
    );
  }

  Widget buildDarkModeRow() {
    final users = Provider.of<SQLiteSettingsRepository>(context, listen: false);
    //users.init();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            // Dark Mode
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.msgDarkMode,
                  style: users.themeData.textTheme.bodyMedium),
              Switch(
                value: users.darkMode, //widget.user.darkMode,
                onChanged: (value) {
                  users.darkMode = value;
                  final sqlRepository = Provider.of<SQLiteSettingsRepository>(
                      context,
                      listen: false);
                  //sqlRepository.init();
                  sqlRepository.insertSetting(
                      Setting(setting: Setting.darkTheme, value: "$value"));
                },
                activeColor: users.themeData.indicatorColor,
              )
            ],
          ),
          Row(
            //Darker Mode
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.msgDarkerMode,
                  style: users.themeData.textTheme.bodyMedium),
              Switch(
                value: users.darkerMode, //widget.user.darkMode,
                onChanged: (value) {
                  users.darkerMode = value;
                  final sqlRepository = Provider.of<SQLiteSettingsRepository>(
                      context,
                      listen: false);
                  //sqlRepository.init();
                  sqlRepository.insertSetting(
                      Setting(setting: Setting.darkerTheme, value: "$value"));
                },
                activeColor: users.themeData.indicatorColor,
              )
            ],
          ),
        ],
      ),
    );
  }

  buildProxyRow() {
    //final users = Provider.of<SQLiteSettingsRepository>(context, listen: false);
    //String dropdownValue = users.useGenius ? services.first : services.last;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0,8.0,16.0,8.0),
      child: Column(
        children: [
          // empty callback function: don't do anything after selection
          ProxySelector(callback: () {}),
        ],
      ),
    );
  }

  buildBackgroundRow() {
    final users = Provider.of<SQLiteSettingsRepository>(context, listen: false);
    //users.init();
    return Padding(
        padding: const EdgeInsets.fromLTRB(16.0,0.0,16.0,0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.msgBlackBackground,
                style: users.themeData.textTheme.bodyMedium),
            Switch(
              value: users.blackBackground, //widget.user.darkMode,
              onChanged: (value) {
                users.blackBackground = value;
                final sqlRepository = Provider.of<SQLiteSettingsRepository>(
                    context,
                    listen: false);
                //sqlRepository.init();
                sqlRepository.insertSetting(
                    Setting(setting: Setting.blackBackground, value: "$value"));
              },
              activeColor: users.themeData.indicatorColor,
            )
          ],
        ));
  }
}
