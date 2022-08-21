import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FirstAccessScreen extends StatelessWidget {
  static const routeName = "/first_access";
  const FirstAccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/logo.svg',
                height: 200,
                width: 200,
              ),
              const SizedBox(
                height: 150,
              ),
              PageView.builder(
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Image.asset(
                    'assets/images/dog_animated.gif',
                    height: 200,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
