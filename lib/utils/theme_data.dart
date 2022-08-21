import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData getThemeData(context) {
  return ThemeData(
    scaffoldBackgroundColor: const Color(0xffF8FAFC),
    primaryColor: const Color(0xff4079AC),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xffF8FAFC),
      titleTextStyle: TextStyle(
        color: Colors.white.withOpacity(0.87),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.teal.shade500,
    ),
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.all<Color>(Colors.grey.shade600),
      thumbColor: MaterialStateProperty.all<Color>(Colors.white),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme,
    ),
  );
}
