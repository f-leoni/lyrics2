import 'package:flutter/material.dart';
import 'package:lyrics_2/models/search_result.dart';
import 'package:lyrics_2/models/lyric.dart';
import 'lyric_detail.dart';

homePageBody() {
  return Column(
    children: [
      Container(
        color: Color.fromRGBO(255, 0, 0, 1),
        child: Text("Ciao!"),
      ),
      Container(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: SearchResult.samples.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  // 8
                  onTap: () {
                    // 9
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          // 10
                          return LyricDetail(lyric: Lyric.samples[index]);
                        },
                      ),
                    );
                  },
                  // 11
                  child: buildSearchResultCard(SearchResult.samples[index]),
                );
              })),
    ],
  );
}

Widget buildSearchResultCard(SearchResult result) {
  return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            //Image(image: AssetImage("assets/B000VDDCRE.01.MZZZZZZZ.jpg")),
            //Text(result.artist + " - " + result.title),
            Text(result.artist,
                style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
                    fontFamily: 'Palatino')),
            Text(
              result.title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                fontFamily: 'Palatino',
              ),
            )
          ],
        ),
      ));
}
