import 'package:adoteme/ui/screens/first_access_screen.dart';
import 'package:adoteme/ui/screens/splash_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

void main() {
  //runApp(DevicePreview(builder: (_) => const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adote-me',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //builder: DevicePreview.appBuilder,
      //locale: DevicePreview.locale(context),

      home: const SplashScreen(),
      routes: {
        FirstAccessScreen.routeName: (context) => const FirstAccessScreen(),
      },
    );
  }
}
