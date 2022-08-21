import 'package:flutter/material.dart';

ThemeData getThemeData() {
  return ThemeData(
    scaffoldBackgroundColor: const Color(0xffF8FAFC),
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
    textTheme: TextTheme(
      bodyText2: TextStyle(
        color: Colors.white.withOpacity(0.6),
      ),
    ),
  );
}
