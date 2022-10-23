import 'package:adoteme/providers.dart';
import 'package:adoteme/ui/screens/about_screen.dart';
import 'package:adoteme/ui/screens/create_account_screen.dart';
import 'package:adoteme/ui/screens/create_publication/animal/address_screen.dart';
import 'package:adoteme/ui/screens/create_publication/animal/animal_photos_screen.dart';
import 'package:adoteme/ui/screens/create_publication/animal/basic_animal_data_screen.dart';
import 'package:adoteme/ui/screens/create_publication/animal/details_animal_screen.dart';
import 'package:adoteme/ui/screens/create_publication/animal/pictures_vaccine_card_screen.dart';
import 'package:adoteme/ui/screens/create_publication/animal/steps_create_publication_screen.dart';
import 'package:adoteme/ui/screens/end_publication_screen.dart';
import 'package:adoteme/ui/screens/create_publication/informative_publication_screen.dart';
import 'package:adoteme/ui/screens/create_publication/select_publication_screen.dart';
import 'package:adoteme/ui/screens/favorites_screen.dart';
import 'package:adoteme/ui/screens/home_screen.dart';
import 'package:adoteme/ui/screens/login_screen.dart';
import 'package:adoteme/ui/screens/my_publications_screen.dart';
import 'package:adoteme/ui/screens/publication_details/adoption_post_details_screen.dart';
import 'package:adoteme/ui/screens/publication_details/informative_post_details_screen.dart';
import 'package:adoteme/ui/screens/publication_details/lost_post_details_screen.dart';
import 'package:adoteme/ui/screens/restore_password_screen.dart';
import 'package:adoteme/ui/screens/splash_screen.dart';
import 'package:adoteme/ui/screens/success_case_screen.dart';
import 'package:adoteme/ui/screens/user_profile_screen.dart';
import 'package:adoteme/utils/theme_data.dart';
import 'package:adoteme/ui/screens/first_access_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adote Animal',
      theme: getThemeData(context),
      // builder: DevicePreview.appBuilder,
      // locale: DevicePreview.locale(context),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      home: const SplashScreen(),
      routes: {
        FirstAccessScreen.routeName: (context) => const FirstAccessScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        UserProfileScreen.routeName: (context) => const UserProfileScreen(),
        DetailsAnimalScreen.routeName: (context) => const DetailsAnimalScreen(),
        AddressScreen.routeName: (context) => const AddressScreen(),
        AnimalPhotosScreen.routeName: (context) => const AnimalPhotosScreen(),
        MyPublicationsScreen.routeName: (context) =>
            const MyPublicationsScreen(),
        StepsCreatePublicationScreen.routeName: (context) =>
            const StepsCreatePublicationScreen(),
        SelectPublicationScreen.routeName: (context) =>
            const SelectPublicationScreen(),
        BasicAnimalDataScreen.routeName: (context) =>
            const BasicAnimalDataScreen(),
        PicturesVaccineCardScreen.routeName: (context) =>
            const PicturesVaccineCardScreen(),
        InformativePublicationScreen.routeName: (context) =>
            const InformativePublicationScreen(),
        AdoptionDetailsScreen.routeName: (context) =>
            const AdoptionDetailsScreen(),
        EndPublicationScreen.routeName: (context) =>
            const EndPublicationScreen(),
        InformativePostDetailsScreen.routeName: (context) =>
            const InformativePostDetailsScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        LostDetailsScreen.routeName: (context) => const LostDetailsScreen(),
        SuccessCaseScreen.routeName: (context) => const SuccessCaseScreen(),
        FavoritesScreen.routeName: (context) => const FavoritesScreen(),
        AboutScreen.routeName: (context) => AboutScreen(),
        CreateAccountScreen.routeName: (context) => const CreateAccountScreen(),
        RestorePasswordScreen.routeName: (context) =>
            const RestorePasswordScreen(),
      },
    );
  }
}
