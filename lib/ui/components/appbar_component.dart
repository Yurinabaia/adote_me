import 'package:flutter/material.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  const AppBarComponent({
    Key? key,
    required this.titulo,
  }) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(70);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppBar(
          leading: const Icon(Icons.menu, color: Color(0xff334155), size: 40),
          title: Center(
            child: Text(
              titulo,
              style: TextStyle(
                color: Color(0xff334155),
                fontSize: 20,
              ),
            ),
          ),
          actions: [
            Icon(Icons.filter_alt_outlined, color: Color(0xff334155), size: 40),
          ],
          backgroundColor: Colors.white,
        ),
      ],
    );
  }
}
