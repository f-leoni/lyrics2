import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LyricsTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.roboto(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
    headline1: GoogleFonts.roboto(
        fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),
    headline2: GoogleFonts.roboto(
        fontSize: 21.0, fontWeight: FontWeight.w700, color: Colors.black),
    headline3: GoogleFonts.roboto(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.roboto(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.white),
    headline1: GoogleFonts.roboto(
        fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
    headline2: GoogleFonts.roboto(
        fontSize: 21.0, fontWeight: FontWeight.w700, color: Colors.white),
    headline3: GoogleFonts.roboto(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white),
  );

  static ThemeData light() {
    return ThemeData(
      primarySwatch: Colors.amber,
      brightness: Brightness.light,
      primaryColor: Colors.white,
      /* colorScheme: //ColorScheme.fromSeed(seedColor: Colors.white),
         ColorScheme(background: Colors.white, secondary: Colors.black),*/
      accentColor: Colors.amber.shade700,
      textTheme: lightTextTheme,
    );
  }

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
