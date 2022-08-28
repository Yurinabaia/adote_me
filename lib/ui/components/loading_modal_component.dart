import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingModalComponent {
  showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
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
        );
      },
    );
  }
}
