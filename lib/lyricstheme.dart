import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LyricsTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.roboto(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
    headline1: GoogleFonts.roboto(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black87),
    headline2: GoogleFonts.roboto(
        fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.white),
    headline3: GoogleFonts.roboto(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black87),
    button: GoogleFonts.roboto(
        fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white70),
    bodyText2: GoogleFonts.roboto(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black87),
    headline4: GoogleFonts.roboto(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black87),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.roboto(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.white70),
    headline1: GoogleFonts.roboto(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white70),
    headline2: GoogleFonts.roboto(
        fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.white70),
    headline3: GoogleFonts.roboto(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white70),
    button: GoogleFonts.roboto(
        fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white70),
    bodyText2: GoogleFonts.roboto(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.white70),
    headline4: GoogleFonts.roboto(
        fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white70),
  );

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.grey.shade100,
      textTheme: lightTextTheme,
      highlightColor: Colors.white70,
      backgroundColor: Colors.green.shade50,
      indicatorColor: Colors.green,
      primaryColorDark: Colors.black87,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightGreen)
          .copyWith(secondary: Colors.lightGreen, brightness: Brightness.light),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.grey.shade700,
      textTheme: darkTextTheme,
      highlightColor: Colors.white70,
      backgroundColor: Colors.grey.shade800,
      indicatorColor: Colors.green.shade500,
      primaryColorDark: Colors.white70,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
          .copyWith(secondary: Colors.greenAccent, brightness: Brightness.dark),
    );
  }
}
