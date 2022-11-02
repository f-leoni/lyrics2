import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
                          const Image(
                              height: 80,
                              image:
                                  AssetImage("assets/lyrics_assets/logo.png")),
                          Text(AppLocalizations.of(context)!.infoTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                        ],
                      ),
                      width: double.infinity,
                      height: 80,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: SizedBox(
                    width: 250,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(AppLocalizations.of(context)!.info,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              wordSpacing: 5)),
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
