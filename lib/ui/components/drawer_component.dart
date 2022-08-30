import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/ui/components/circle_avatar_component.dart';
import 'package:adoteme/ui/components/texts/body_text_component.dart';
import 'package:adoteme/ui/components/texts/label_text_component.dart';
import 'package:adoteme/ui/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DrawerComponent extends StatefulWidget {
  int selectIndex;
  DrawerComponent({Key? key, this.selectIndex = 0}) : super(key: key);

  @override
  State<DrawerComponent> createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  List<Map<String, dynamic>> itemsMenu = [
    {
      'name': 'Página inicial',
      'icon': Icons.home_outlined,
      'route': '/user_profile',
    },
    {
      'name': 'Favoritos',
      'icon': Icons.favorite_outline,
      'route': '/user_profile',
    },
    {
      'name': 'Minhas publicações',
      'icon': Icons.newspaper,
      'route': '/user_profile',
    },
    {
      'name': 'Caso de sucesso',
      'icon': Icons.task_alt_sharp,
      'route': '/user_profile',
    },
    {
      'name': 'Perfil',
      'icon': Icons.account_circle_outlined,
      'route': '/user_profile',
    },
  ];
  @override
  Widget build(BuildContext context) {
    final auth = context.read<LoginFirebaseService>();
    return Drawer(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 75,
                    width: 75,
                    child: CircleAvatarComponent.findCircleAvatar(),
                  ),
                  const SizedBox(height: 16),
                  const LabelTextComponent(text: 'teste@teste.com')
                ],
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: itemsMenu.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: Icon(
                    itemsMenu[index]['icon'],
                    color: widget.selectIndex == index
                        ? Colors.white
                        : const Color(0xff334155),
                    size: 28,
                  ),
                  title: BodyTextComponent(
                    text: itemsMenu[index]['name'],
                    selectedText: widget.selectIndex == index,
                  ),
                  onTap: () {
                    selectAction(index);
                    Navigator.pushReplacementNamed(
                        context, itemsMenu[index]['route']);
                  },
                  selectedTileColor: Theme.of(context).primaryColor,
                  selected: widget.selectIndex == index,
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Color(0xff334155),
                size: 28,
              ),
              title: const BodyTextComponent(
                text: 'Desconectar-se',
              ),
              onTap: () {
                auth.signOut();
                Navigator.pushReplacementNamed(context, Login.routeName);
              },
              selectedTileColor: Theme.of(context).primaryColor,
            ),
            // TODO : implementar o sobre-nós
            // const AboutListTile(
            //   icon: Icon(
            //     Icons.info,
            //   ),
            //   child: Text('About app'),
            //   applicationIcon: Icon(
            //     Icons.local_play,
            //   ),
            //   applicationName: 'My Cool App',
            //   applicationVersion: '1.0.25',
            //   applicationLegalese: '© 2019 Company',
            //   aboutBoxChildren: [
            //     ///Content goes here...
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  selectAction(int index) {
    setState(() {
      widget.selectIndex = index;
    });
  }
}
