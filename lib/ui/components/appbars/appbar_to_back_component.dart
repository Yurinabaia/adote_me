import 'package:flutter/material.dart';

class AppBarToBackComponent extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarToBackComponent({Key? key}) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(56);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Criar publicação",
        style: TextStyle(
          color: Color(0xff334155),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: Color(0xff334155),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      centerTitle: true,
    );
  }
}
