import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:lyrics2/models/app_state_manager.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class InfoScreen extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: LyricsPages.infoPath,
      key: ValueKey(LyricsPages.infoPath),
      child: const InfoScreen(),
    );
  }

  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final manager = Provider.of<AppStateManager>(context, listen: false);
    final users = Provider.of<FirebaseUserRepository>(context, listen: false);
    late final String version;
    late final String build;
    final bool isDark = users.darkMode;
    final theme = users.themeData;
    final logoImg = isDark
        ? const AssetImage('assets/lyrics_assets/logo_dark.png')
        : const AssetImage('assets/lyrics_assets/logo.png');

    return SafeArea(
      child: Center(
        child: Container(
          color: theme.primaryColor,
          //MediaQuery.of(context).size.width
          constraints: const BoxConstraints.expand(width: 400, height: 650),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  //color: Colors.yellow,
                  child: Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Provider.of<AppStateManager>(context,
                                      listen: false)
                                  .goToTab(LyricsTab.search);
                            },
                          ),
                          Image(height: 80, image: logoImg),
                          //AssetImage("assets/lyrics_assets/logo.png")),
                          Text(AppLocalizations.of(context)!.infoTitle,
                              style: theme.textTheme.headline1),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: SizedBox(
                    width: 250,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Consumer<AppStateManager>(
                          builder: (context, appStateManager, child) {
                        Provider.of<AppStateManager>(context, listen: false)
                            .getVersionInfo();
                        return Column(
                          children: [
                            Text(AppLocalizations.of(context)!.info,
                                style: theme.textTheme.headline4),
                            const SizedBox(height: 30),
                            FutureBuilder(
                              future: Provider.of<AppStateManager>(context,
                                      listen: false)
                                  .getVersionInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasData) {
                                    var result = snapshot.data as List<String>;
                                    version = result[0];
                                    build = result[1];
                                    return Text(
                                      "Version: $version - Build: $build\n",
                                      style: theme.textTheme.headline3,
                                    );
                                  } else {
                                    return Container(); //Text("Retrieving version info....");
                                  }
                                } else {
                                  return Container(); //Text("Retrieving version info...");
                                }
                              },
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
