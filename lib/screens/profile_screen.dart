import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:provider/provider.dart';
import 'package:lyrics2/components/circle_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics2/models/models.dart';

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
  static const List<String> services = <String>['Genius', 'ChartLyrics'];
  @override
  Widget build(BuildContext context) {
    var users = Provider.of<FirebaseUserRepository>(context, listen: false);
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
            style: users.themeData.textTheme.headline2),
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
        buildProxyRow(),
        /*ListTile(
          title: const Text('View raywenderlich.com'),
          onTap: () {
            // Open raywenderlich.com webview
            Provider.of<FirebaseUserRepository>(context, listen: false)
                .tapOnRaywenderlich(true);
          },
        ),*/
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

  Widget buildDarkModeRow() {
    final users = Provider.of<FirebaseUserRepository>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppLocalizations.of(context)!.msgDarkMode,
              style: users.themeData.textTheme.bodyText2),
          Switch(
            value: users.darkMode, //widget.user.darkMode,
            onChanged: (value) {
              users.darkMode = value;
            },
            activeColor: users.themeData.indicatorColor,
          )
        ],
      ),
    );
  }

  Widget buildProfile() {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final users = Provider.of<FirebaseUserRepository>(context, listen: false);
    return Column(
      children: [
        CircleImage(
          imageProvider: users.userImage,
          imageRadius: 60.0,
        ),
        const SizedBox(height: 8.0),
        Text(widget.user.email!, style: users.themeData.textTheme.headline1),
        Text(
            "Registration date: ${formatter.format(widget.user.metadata.creationTime!)}"), //role
      ],
    );
  }

  buildProxyRow() {
    final users = Provider.of<FirebaseUserRepository>(context, listen: false);
    String dropdownValue = users.useGenius ? services.first : services.last;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.msgUseGenius,
                  style: users.themeData.textTheme.bodyText2),
              Switch(
                value: users.useGenius, //widget.user.darkMode,
                onChanged: (value) {
                  users.useGenius = value;
                },
                activeColor: users.themeData.indicatorColor,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.msgUseCL,
                  style: users.themeData.textTheme.bodyText2),
              Switch(
                value: !users.useGenius, //widget.user.darkMode,
                onChanged: (value) {
                  users.useGenius = !value;
                },
                activeColor: users.themeData.indicatorColor,
              )
            ],
          ),*/
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.msgUseService,
                  style: users.themeData.textTheme.bodyText2),
              DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.miscellaneous_services),
                  items: services.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: users.themeData.textTheme.bodyText2,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                      if (dropdownValue == services.first) {
                        users.useGenius = true;
                      } else {
                        users.useGenius = false;
                      }
                    });
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
