import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

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
            const Text(
              'Nothing here!',
              style: TextStyle(fontSize: 21.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Add some favorites!\n'
              'Tap the button to search for some lyrics!',
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
                //Provider.of<TabManager>(context, listen: false).goToRecipes();
              },
            ),
          ],
        ),
      ),
    );
  }
}
