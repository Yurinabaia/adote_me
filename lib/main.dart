import 'package:adoteme/providers.dart';
import 'package:adoteme/ui/screens/create_publication/basic_animal_data_screen.dart';
import 'package:adoteme/ui/screens/create_publication/select_publication_screen.dart';
import 'package:adoteme/ui/screens/create_publication/steps_create_publication.dart';
import 'package:adoteme/ui/screens/login_screen.dart';
import 'package:adoteme/ui/screens/my_publications_screen.dart';
import 'package:adoteme/ui/screens/user_profile_screen.dart';
import 'package:adoteme/utils/theme_data.dart';
import 'package:adoteme/ui/screens/first_access_screen.dart';
import 'package:adoteme/ui/screens/splash_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (_) => MultiProvider(
        providers: providers,
        child: const MyApp(),
      ),
    ),
  );
  // runApp(MultiProvider(providers: providers, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adote-me',
      theme: getThemeData(context),
      // builder: DevicePreview.appBuilder,
      // locale: DevicePreview.locale(context),
      home: const BasicAnimalDataScreen(),
      routes: {
        FirstAccessScreen.routeName: (context) => const FirstAccessScreen(),
        Login.routeName: (context) => const Login(),
        UserProfileScreen.routeName: (context) => const UserProfileScreen(),
        MyPublicationsScreen.routeName: (context) => const MyPublicationsScreen(),
        StepsCreatePublicationScreen.routeName: (context) =>
            const StepsCreatePublicationScreen(),
        SelectPublicationScreen.routeName: (context) =>
            const SelectPublicationScreen(),
      },
    );
  }
}
