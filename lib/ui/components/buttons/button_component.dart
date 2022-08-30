import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonComponent extends StatelessWidget {
  final String text;
  final Function onPressed;
  final String? svgIcon;
  final Color? color;

  const ButtonComponent({
    Key? key,
    required this.text,
    required this.onPressed,
    this.svgIcon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        primary: color ?? const Color(0xff4079AC),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        minimumSize: const Size.fromHeight(50),
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (svgIcon != null) ...[
            SvgPicture.asset(
              'assets/images/$svgIcon.svg',
              height: 24,
              width: 24,
            ),
            const SizedBox(
              width: 20,
            ),
          ],
          Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
