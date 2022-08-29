import 'package:flutter/material.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  const AppBarComponent({
    Key? key,
    required this.titulo,
  }) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(56);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(
              Icons.menu,
              color: Color(0xff334155),
              size: 40,
            ),
          );
        }),
        title: Center(
          child: Text(
            titulo,
            style: const TextStyle(
              color: Color(0xff334155),
              fontSize: 20,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_alt_outlined,
                color: Color(0xff334155), size: 40),
          ),
        ],
        centerTitle: true,
      ),
    );
  }
}
