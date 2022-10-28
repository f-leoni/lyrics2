import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      child: Center(
        child: Container(
          //MediaQuery.of(context).size.width
          constraints: const BoxConstraints.expand(width: 450, height: 450),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: const EdgeInsets.all(26),
                //color: Colors.yellow,
                child: Center(
                  child: SizedBox(
                    child: Row(
                      children: [
                        const Image(
                            height: 250,
                            image: AssetImage("assets/lyrics_assets/logo.png")),
                        Text(AppLocalizations.of(context)!.infoTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            )),
                      ],
                    ),
                    width: double.infinity,
                    height: 200,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(AppLocalizations.of(context)!.info,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          wordSpacing: 5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
