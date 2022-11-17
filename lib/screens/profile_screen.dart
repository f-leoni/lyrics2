import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:provider/provider.dart';
import '../components/circle_image.dart';
import '../models/models.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Close Profile Screen
            Provider.of<FirebaseUserRepository>(context, listen: false)
                .tapOnProfile(false);
          },
        ),
      ),
      body: Center(
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
          title: const Text('Log out'),
          onTap: () {
            // Logout user
            // 1
            Provider.of<FirebaseUserRepository>(context, listen: false)
                .tapOnProfile(false);
            // 2
            Provider.of<AppStateManager>(context, listen: false)
                .logout(context);
          },
        )
      ],
    );
  }

  Widget buildDarkModeRow() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Dark Mode'),
          Switch(
            value: Provider.of<FirebaseUserRepository>(context, listen: false)
                .darkMode, //widget.user.darkMode,
            onChanged: (value) {
              Provider.of<FirebaseUserRepository>(context, listen: false)
                  .darkMode = value;
            },
          )
        ],
      ),
    );
  }

  Widget buildProfile() {
    return Column(
      children: [
        CircleImage(
          imageProvider:
              Provider.of<FirebaseUserRepository>(context, listen: false)
                  .userImage,
          imageRadius: 60.0,
        ),
        const SizedBox(height: 16.0),
        Text(
          widget.user.email!,
          style: const TextStyle(
            fontSize: 21,
          ),
        ),
        Text(widget.user.metadata.creationTime.toString()), //role
        /*Text(
          'Username: ${widget.user.email}',
          style: const TextStyle(
            fontSize: 30,
            color: Colors.green,
          ),
        ),*/
      ],
    );
  }

  buildProxyRow() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Use Genius Proxy'),
          Switch(
            value: Provider.of<FirebaseUserRepository>(context, listen: false)
                .useGenius, //widget.user.darkMode,
            onChanged: (value) {
              Provider.of<FirebaseUserRepository>(context, listen: false)
                  .useGenius = value;
            },
          )
        ],
      ),
    );
  }
}
