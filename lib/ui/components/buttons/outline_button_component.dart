import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OutlineButtonComponent extends StatelessWidget {
  final String text;
  final Function onPressed;
  final String? svgIcon;
  final bool islogin;

  const OutlineButtonComponent({
    Key? key,
    required this.text,
    required this.onPressed,
    this.svgIcon,
    this.islogin = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        minimumSize: const Size.fromHeight(50),
        shape: const StadiumBorder(),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: islogin ? 0 : 2,
        ),
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
            if (text.isNotEmpty)
              const SizedBox(
                width: 20,
              ),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
