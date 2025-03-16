import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LyricsTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: GoogleFonts.lato(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
    displayLarge: GoogleFonts.lato(
        fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black87),
    displayMedium: GoogleFonts.lato(
        fontSize: 22.0, fontWeight: FontWeight.w700, color: Colors.white),
    displaySmall: GoogleFonts.lato(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black87),
    labelLarge: GoogleFonts.lato(
        fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white70),
    bodyMedium: GoogleFonts.lato(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black87),
    headlineMedium: GoogleFonts.lato(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black87),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyLarge: GoogleFonts.lato(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.white70),
    displayLarge: GoogleFonts.lato(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white70),
    displayMedium: GoogleFonts.lato(
        fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.white70),
    displaySmall: GoogleFonts.lato(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white70),
    labelLarge: GoogleFonts.lato(
        fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white70),
    bodyMedium: GoogleFonts.lato(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.white70),
    headlineMedium: GoogleFonts.lato(
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
      indicatorColor: Colors.green.shade500,
      primaryColorDark: Colors.white70, colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
          .copyWith(secondary: Colors.greenAccent, brightness: Brightness.dark).copyWith(surface: Colors.grey.shade800),
    );
  }
}
