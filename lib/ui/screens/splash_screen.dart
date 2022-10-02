import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:is_first_run/is_first_run.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = "/loading";
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Timer(const Duration(seconds: 5), () async {
      bool firstAccess = await IsFirstRun.isFirstRun();
      Navigator.pushReplacementNamed(
          context, firstAccess ? '/first_access' : '/login');
    });
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/logo.svg',
                height: 200,
                width: 200,
              ),
              const SizedBox(
                height: 150,
              ),
              Image.asset(
                'assets/images/dog_animated.gif',
                height: 200,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    "Encontre",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    " seu animal de estimação",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
