import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/lyric.dart';

class LyricTile extends StatelessWidget {
  final Lyric item;
  final Function(bool?)? onComplete;
  final TextDecoration textDecoration;

  LyricTile({Key? key, required this.item, this.onComplete})
      : textDecoration = TextDecoration.none,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 5.0, color: Colors.amber),
              const SizedBox(width: 16.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.lato(
                        decoration: textDecoration,
                        fontSize: 21.0,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  buildAuthor(),
                  const SizedBox(height: 4.0),
                  //buildImportance(),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Text(
                item.album.toString(),
                style: GoogleFonts.lato(
                    decoration: textDecoration, fontSize: 21.0),
              ),
              //buildCheckbox(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildImportance() {
    return Text("...");
    /*if (item.importance == Importance.low) {
      return Text('Low', style: GoogleFonts.lato(decoration: textDecoration));
    } else if (item.importance == Importance.medium) {
      return Text('Medium',
          style: GoogleFonts.lato(
              fontWeight: FontWeight.w800, decoration: textDecoration));
    } else if (item.importance == Importance.high) {
      return Text(
        'High',
        style: GoogleFonts.lato(
          color: Colors.red,
          fontWeight: FontWeight.w900,
          decoration: textDecoration,
        ),
      );
    } else {
      throw Exception('This importance type does not exist');
    }*/
  }

  Widget buildAuthor() {
    return Text(
      item.author,
      style: TextStyle(decoration: textDecoration),
    );
  }
}
