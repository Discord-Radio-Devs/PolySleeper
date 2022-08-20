import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData getDefaultTheme(BuildContext context) {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xff201f47),
    colorScheme: ColorScheme(
        primary: Colors.green[300]!,
        primaryContainer: Colors.green[600]!,
        secondary: Colors.indigo[600]!,
        secondaryContainer: Colors.deepPurple[800]!,
        surface: const Color(0xff201f47),
        background: const Color(0xff201f47),
        error: Colors.red[400]!,
        onPrimary: Colors.blueGrey[700]!,
        onSecondary: const Color(0xFF323367),
        onSurface: Colors.indigo[400]!,
        onBackground: Colors.indigo[400]!,
        onError: Colors.red[50]!,
        brightness: Brightness.dark),
    textTheme: Theme.of(context)
        .textTheme
        .apply(
          fontFamily: GoogleFonts.nunito().fontFamily,
          displayColor: Colors.indigo[300],
          bodyColor: Colors.indigo,
        )
        .merge(TextTheme(
            headline1: const TextStyle(fontSize: 32, letterSpacing: 0.5),
            headline2: const TextStyle(fontSize: 28),
            headline3: GoogleFonts.montserrat(
              fontSize: 24,
              color: Colors.green[300],
            ),
            headline4: GoogleFonts.montserrat(
              fontSize: 21,
              color: Colors.deepPurple[400],
              fontWeight: FontWeight.w300,
            ))),
    iconTheme: IconThemeData(
      color: Colors.blueGrey[700],
    ),
    timePickerTheme: TimePickerThemeData(
        helpTextStyle: TextStyle(color: Colors.indigo[300])),
  );
}
