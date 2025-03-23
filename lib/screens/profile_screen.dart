import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:provider/provider.dart';
import 'package:lyrics2/components/circle_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics2/models/models.dart';
import 'package:lyrics2/components/proxy_selector.dart'; // Importa il nuovo componente

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
    super.key,
    required this.user,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

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
    var users = Provider.of<FirebaseUserRepository>(context, listen: false);
    return ListView(
      children: [
        buildDarkModeRow(),
        const ProxySelector(),
        ListTile(
          title: Center(child: Text(AppLocalizations.of(context)!.msgLogout,
            style: users.themeData.textTheme.headlineMedium,)),
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
              style: users.themeData.textTheme.bodyMedium),
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
        Text(widget.user.email!, style: users.themeData.textTheme.titleLarge),
        Text("${AppLocalizations.of(context)!.msgRegistrationDate} ${formatter.format(widget.user.metadata.creationTime!)}"), //role
      ],
    );
  }
}