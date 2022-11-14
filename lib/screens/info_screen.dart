import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:lyrics2/data/sqlite_settings_repository.dart';
import 'package:lyrics2/data/sqlite_settings_repository.dart';
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
    bool isDark =
        Provider.of<FirebaseUserRepository>(context, listen: false).darkMode;
    final logoImg = isDark
        ? const AssetImage('assets/lyrics_assets/logo_dark.png')
        : const AssetImage('assets/lyrics_assets/logo.png');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            //MediaQuery.of(context).size.width
            constraints: const BoxConstraints.expand(width: 350, height: 550),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
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
                            Text("${AppLocalizations.of(context)!.info}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    wordSpacing: 5)),
                            const SizedBox(height: 30),
                            Text(
                                "Version: ${Provider.of<AppStateManager>(context, listen: false).version} - Build: ${Provider.of<AppStateManager>(context, listen: false).buildNr}\n",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    wordSpacing: 5)),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                /*TextButton(
                  child: const Text("Logout"),
                  onPressed: () {
                    var manager =
                        Provider.of<AppStateManager>(context, listen: false);
                    manager.logout(context);
                    final sqlRepository = Provider.of<SQLiteSettingsRepository>(
                        context,
                        listen: false);
                    sqlRepository.deleteSetting(Setting.onboardingComplete);
                  },
                )*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
