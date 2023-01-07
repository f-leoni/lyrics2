import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LyricsTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.lato(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
    headline1: GoogleFonts.lato(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black87),
    headline2: GoogleFonts.lato(
        fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.white),
    headline3: GoogleFonts.lato(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black87),
    button: GoogleFonts.lato(
        fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white70),
    bodyText2: GoogleFonts.lato(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black87),
    headline4: GoogleFonts.lato(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black87),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.lato(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.white70),
    headline1: GoogleFonts.lato(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white70),
    headline2: GoogleFonts.lato(
        fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.white70),
    headline3: GoogleFonts.lato(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white70),
    button: GoogleFonts.lato(
        fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white70),
    bodyText2: GoogleFonts.lato(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.white70),
    headline4: GoogleFonts.lato(
        fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white70),
  );

  static ThemeData light() {
    return ThemeData(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      brightness: Brightness.light,
      primaryColor: Colors.grey.shade100,
      textTheme: lightTextTheme,
      highlightColor: Colors.white70,
      backgroundColor: Colors.blue.shade50,
      indicatorColor: Colors.blue,
      primaryColorDark: Colors.black87,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightBlue)
          .copyWith(secondary: Colors.lightBlue, brightness: Brightness.light),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
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
