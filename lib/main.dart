import 'package:adoteme/providers.dart';
import 'package:adoteme/ui/screens/login_screen.dart';
import 'package:adoteme/ui/screens/user_profile_screen.dart';
import 'package:adoteme/utils/theme_data.dart';
import 'package:adoteme/ui/screens/first_access_screen.dart';
import 'package:adoteme/ui/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  // runApp(DevicePreview(builder: (_) => const MyApp()));
  runApp(MultiProvider(providers: providers, child: const MyApp()));
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
      home: const SplashScreen(),
      routes: {
        FirstAccessScreen.routeName: (context) => const FirstAccessScreen(),
        Login.routeName: (context) => const Login(),
        UserProfileScreen.routeName: (context) => const UserProfileScreen(),
      },
    );
  }
}
