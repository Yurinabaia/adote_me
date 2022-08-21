import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonOutlineComponent extends StatelessWidget {
  final String text;
  final Function onPressed;
  final String? svgIcon;
  final Color? textColor;
  const ButtonOutlineComponent(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.svgIcon,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        minimumSize: const Size.fromHeight(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (svgIcon != null)
            SvgPicture.asset(
              'assets/images/$svgIcon.svg',
              height: 24,
              width: 24,
            ),
          const SizedBox(
            width: 20,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor ?? Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
