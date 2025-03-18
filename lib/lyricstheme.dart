import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LyricsTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.lato(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white70),
    displayMedium: GoogleFonts.lato(
        fontSize: 20.0, fontWeight: FontWeight.w700, color: Colors.white70),
    displaySmall: GoogleFonts.lato(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white70),
    headlineLarge: GoogleFonts.lato(
        fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black87),
    headlineMedium: GoogleFonts.lato(
        fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.black87),
    headlineSmall: GoogleFonts.lato(
        fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.black87),
    titleLarge: GoogleFonts.lato(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black87),
    titleMedium: GoogleFonts.lato(
        fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.black87),
    titleSmall: GoogleFonts.lato(
        fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.black87),
    labelLarge: GoogleFonts.lato(
        fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white70),
    labelMedium: GoogleFonts.lato(
        fontSize: 14.0, fontWeight: FontWeight.w700, color: Colors.white70),
    labelSmall: GoogleFonts.lato(
        fontSize: 12.0, fontWeight: FontWeight.w700, color: Colors.white70),
    bodyLarge: GoogleFonts.lato(
        fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.black87),
    bodyMedium: GoogleFonts.lato(
        fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.black87),
    bodySmall: GoogleFonts.lato(
        fontSize: 10.0, fontWeight: FontWeight.normal, color: Colors.black87),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.lato(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black87),
    displayMedium: GoogleFonts.lato(
        fontSize: 20.0, fontWeight: FontWeight.w700, color: Colors.black87),
    displaySmall: GoogleFonts.lato(
        fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.black87),
    headlineLarge: GoogleFonts.lato(
        fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white70),
    headlineMedium: GoogleFonts.lato(
        fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white70),
    headlineSmall: GoogleFonts.lato(
        fontSize: 12.0, fontWeight: FontWeight.w300, color: Colors.white70),
    titleLarge: GoogleFonts.lato(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white70),
    titleMedium: GoogleFonts.lato(
        fontSize: 18.0, fontWeight: FontWeight.w300, color: Colors.white70),
    titleSmall: GoogleFonts.lato(
        fontSize: 14.0, fontWeight: FontWeight.w300, color: Colors.white70),
    labelLarge: GoogleFonts.lato(
        fontSize: 16.0, fontWeight: FontWeight.w700, color: Colors.white70),
    labelMedium: GoogleFonts.lato(
        fontSize: 14.0, fontWeight: FontWeight.w700, color: Colors.white70),
    labelSmall: GoogleFonts.lato(
        fontSize: 12.0, fontWeight: FontWeight.w700, color: Colors.white70),
    bodyLarge: GoogleFonts.lato(
        fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white70),
    bodyMedium: GoogleFonts.lato(
        fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white70),
    bodySmall: GoogleFonts.lato(
        fontSize: 10.0, fontWeight: FontWeight.normal, color: Colors.white70),
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
      hintColor: Colors.black45,
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
      primaryColor: Colors.black87,
      textTheme: darkTextTheme,
      highlightColor: Colors.white70,
      indicatorColor: Colors.green.shade500,
      primaryColorDark: Colors.white70,
      hintColor: Colors.white24,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
          .copyWith(secondary: Colors.greenAccent, brightness: Brightness.dark).copyWith(surface: Colors.grey.shade800),
    );
  }
}
