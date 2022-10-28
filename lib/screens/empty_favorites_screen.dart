import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyFavoritesScreen extends StatelessWidget {
  const EmptyFavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset('assets/lyrics_assets/empty_favorites.png'),
            ),
            const SizedBox(height: 8.0),
            Text(
              AppLocalizations.of(context)!.nothingHere,
              style: const TextStyle(fontSize: 21.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              AppLocalizations.of(context)!.emptyFavsLine1 +
                  AppLocalizations.of(context)!.emptyFavsLine2,
              textAlign: TextAlign.center,
            ),
            MaterialButton(
              textColor: Colors.white,
              child: const Text('Search'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.green,
              onPressed: () {
                //Provider.of<TabManager>(context, listen: false).goToLyrics();
              },
            ),
          ],
        ),
      ),
    );
  }
}
