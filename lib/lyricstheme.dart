import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LyricsTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.openSans(
        fontSize: 14.0, fontWeight: FontWeight.w700, color: Colors.black),
    headline1: GoogleFonts.openSans(
        fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),
    headline2: GoogleFonts.openSans(
        fontSize: 21.0, fontWeight: FontWeight.w700, color: Colors.black),
    headline3: GoogleFonts.openSans(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.openSans(
        fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.white),
    headline1: GoogleFonts.openSans(
        fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
    headline2: GoogleFonts.openSans(
        fontSize: 21.0, fontWeight: FontWeight.w700, color: Colors.white),
    headline3: GoogleFonts.openSans(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white),
  );

// 3
  static ThemeData light() {
    return ThemeData(
      primarySwatch: Colors.amber,
      brightness: Brightness.light,
      primaryColor: Colors.white,
      accentColor: Colors.black,
      textTheme: lightTextTheme,
    );
  }

// 4
  static ThemeData dark() {
    return ThemeData(
      primarySwatch: Colors.amber,
      brightness: Brightness.dark,
      primaryColor: Colors.grey[900],
      accentColor: Colors.green[600],
      textTheme: darkTextTheme,
    );
  }
}
