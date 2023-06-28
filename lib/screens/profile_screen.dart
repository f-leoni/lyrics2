import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:provider/provider.dart';
import 'package:lyrics2/components/circle_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics2/models/models.dart';

import '../components/proxy_selector.dart';
import '../data/sqlite_settings_repository.dart';

class ProfileScreen extends StatefulWidget {
  // ProfileScreen MaterialPage Helper
  static MaterialPage page(User user) {
    return MaterialPage(
      name: LyricsPages.profilePath,
      key: ValueKey(LyricsPages.profilePath),
      child: ProfileScreen(user: user),
    );
  }

  final User user;
  const ProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //static const List<String> services = <String>['Genius', 'ChartLyrics'];
  @override
  Widget build(BuildContext context) {
    var users = Provider.of<FirebaseUserRepository>(context, listen: false);
    var settings = Provider.of<SQLiteSettingsRepository>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: settings.themeData.colorScheme.primaryContainer,
        leading: IconButton(
          icon: Icon(Icons.close,
              size: 30, color: settings.themeData.highlightColor),
          onPressed: () {
            // Close Profile Screen
            users.tapOnProfile(false);
          },
        ),
        title: Text(AppLocalizations.of(context)!.ttlProfile,
            style: settings.themeData.textTheme.displayMedium),
      ),
      body: Container(
        color: settings.themeData.primaryColor,
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
        ListTile(
          title: Center(child: Text(AppLocalizations.of(context)!.msgLogout)),
          onTap: () {
            // Logout user
            Provider.of<FirebaseUserRepository>(context, listen: false)
                .tapOnProfile(false);
            Provider.of<AppStateManager>(context, listen: false)
                .logout(context);
          },
        )
      ],
    );
  }

  Widget buildProfile() {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final users = Provider.of<FirebaseUserRepository>(context, listen: false);
    final settings = Provider.of<SQLiteSettingsRepository>(context, listen: false);
    return Column(
      children: [
        CircleImage(
          imageProvider: users.userImage,
          imageRadius: 60.0,
        ),
        const SizedBox(height: 8.0),
        Text(widget.user.email!, style: settings.themeData.textTheme.displayLarge),
        Text(
            "Registration date: ${formatter.format(widget.user.metadata.creationTime!)}"), //role
      ],
    );
  }

  Widget buildDarkModeRow() {
    //final users = Provider.of<FirebaseUserRepository>(context, listen: false);
    final SQLiteSettingsRepository settings = Provider.of<SQLiteSettingsRepository>(context, listen: false);
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
                  style: settings.themeData.textTheme.bodyMedium),
              Switch(
                value: settings.darkMode, //widget.user.darkMode,
                onChanged: (value) {
                  settings.darkMode = value;
                  settings.insertSetting(
                      Setting(setting: Setting.darkTheme, value: "$value"));
                },
                activeColor: settings.themeData.indicatorColor,
              )
            ],
          ),
          Row(
            //Darker Mode
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.msgDarkerMode,
                  style: settings.themeData.textTheme.bodyMedium),
              Switch(
                value: settings.darkerMode, //widget.user.darkMode,
                onChanged: (value) {
                  settings.darkerMode = value;
                  //sqlRepository.init();
                  settings.insertSetting(
                      Setting(setting: Setting.darkerTheme, value: "$value"));
                },
                activeColor: settings.themeData.indicatorColor,
              )
            ],
          ),
        ],
      ),
    );
  }

  buildProxyRow() {
    //final users = Provider.of<FirebaseUserRepository>(context, listen: false);
    //String dropdownValue = users.useGenius ? services.first : services.last;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0,8.0,16.0,8.0),
      child: Column(
        children: [
          ProxySelector(callback: (BuildContext context) {}),
        ],
      ),
    );
  }

  buildBackgroundRow() {
    final settings = Provider.of<SQLiteSettingsRepository>(context, listen: false);
    //users.init();
    return Padding(
        padding: const EdgeInsets.fromLTRB(16.0,0.0,16.0,0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.msgBlackBackground,
                style: settings.themeData.textTheme.bodyMedium),
            Switch(
              value: settings.blackBackground, //widget.user.darkMode,
              onChanged: (value) {
                settings.blackBackground = value;
                final sqlRepository = Provider.of<SQLiteSettingsRepository>(
                    context,
                    listen: false);
                //sqlRepository.init();
                sqlRepository.insertSetting(
                    Setting(setting: Setting.blackBackground, value: "$value"));
              },
              activeColor: settings.themeData.indicatorColor,
            )
          ],
        ));
  }

}
