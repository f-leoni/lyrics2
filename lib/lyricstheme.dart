import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LyricsTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.roboto(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
    headline1: GoogleFonts.roboto(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white),
    headline2: GoogleFonts.roboto(
        fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.black),
    headline3: GoogleFonts.roboto(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black),
    button: GoogleFonts.roboto(
        fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white70),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.roboto(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.white),
    headline1: GoogleFonts.roboto(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black87),
    headline2: GoogleFonts.roboto(
        fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.white),
    headline3: GoogleFonts.roboto(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white),
    button: GoogleFonts.roboto(
        fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white70),
  );

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.grey.shade100,
      textTheme: lightTextTheme,
      highlightColor: Colors.white70,
      backgroundColor: Colors.green.shade50,
      indicatorColor: Colors.green,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightGreen)
          .copyWith(secondary: Colors.green, brightness: Brightness.light),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.grey.shade700,
      textTheme: darkTextTheme,
      highlightColor: Colors.white70,
      backgroundColor: Colors.grey.shade700,
      indicatorColor: Colors.green.shade500,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
          .copyWith(secondary: Colors.greenAccent, brightness: Brightness.dark),
    );
  }
}
