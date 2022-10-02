// ignore_for_file: use_build_context_synchronously

import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/data/service/user_profile_firebase_service.dart';
import 'package:adoteme/ui/components/alerts/alert_dialog_component.dart';
import 'package:adoteme/ui/components/alerts/alert_login_component.dart';
import 'package:adoteme/ui/components/circle_avatar_component.dart';
import 'package:adoteme/ui/components/loading_modal_component.dart';
import 'package:adoteme/ui/components/texts/body_text_component.dart';
import 'package:adoteme/ui/components/texts/label_text_component.dart';
import 'package:adoteme/ui/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MenuDrawerComponent extends StatefulWidget {
  int selectIndex;
  MenuDrawerComponent({Key? key, this.selectIndex = 0}) : super(key: key);

  @override
  State<MenuDrawerComponent> createState() => _MenuDrawerComponentState();
}

class _MenuDrawerComponentState extends State<MenuDrawerComponent> {
  String? _imgFirebase;
  final ValueNotifier<String> _emailUser = ValueNotifier('');
  final ValueNotifier<String> _idUser = ValueNotifier('');
  UserProfileFirebaseService userProfileFirebaseService =
      UserProfileFirebaseService();
  List<Map<String, dynamic>> itemsMenu = [
    {
      'name': 'Página inicial',
      'icon': Icons.home_outlined,
      'route': '/home',
      'loginRequired': false,
    },
    {
      'name': 'Favoritos',
      'icon': Icons.favorite_outline,
      'route': '/favorites',
      'loginRequired': true,
    },
    {
      'name': 'Minhas publicações',
      'icon': Icons.newspaper,
      'route': '/my_publications',
      'loginRequired': true,
    },
    {
      'name': 'Caso de sucesso',
      'icon': Icons.task_alt_sharp,
      'route': '/success_case',
      'loginRequired': false,
    },
    {
      'name': 'Perfil',
      'icon': Icons.account_circle_outlined,
      'route': '/user_profile',
      'loginRequired': true,
    },
  ];

  void startData() async {
    var dataUser =
        await userProfileFirebaseService.getUserProfile(_idUser.value);
    if (dataUser.data() != null && dataUser.data()!['image'] != null) {
      setState(() {
        _imgFirebase = dataUser['image'];
      });
    }
  }

  @override
  void initState() {
    var auth = context.read<LoginFirebaseService>();
    _emailUser.value = auth.emailFirebase();
    _idUser.value = auth.idFirebase();
    if (_idUser.value != '') {
      startData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<LoginFirebaseService>();
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 75,
                  width: 75,
                  child: CircleAvatarComponent.findCircleAvatar(
                      imgFirebase: _imgFirebase),
                ),
                const SizedBox(height: 16),
                LabelTextComponent(
                    text: _emailUser.value != ''
                        ? _emailUser.value
                        : 'Usuário não logado'),
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
                  if (itemsMenu[index]['loginRequired'] &&
                      _idUser.value == '') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertLoginComponent();
                      },
                    );
                  } else {
                    selectAction(index);
                    Navigator.pushReplacementNamed(
                        context, itemsMenu[index]['route']);
                  }
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
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) => const AlertDialogComponent(
                  statusType: 'error',
                  title: 'Deseja sair?',
                  message:
                      'Desconectar conta do usuário atual e voltar para a tela de login.',
                ),
              ).then((value) async {
                if (value) {
                  auth.signOut();
                  Navigator.pushReplacementNamed(
                      context, LoginScreen.routeName);
                }
              });
            },
            selectedTileColor: Theme.of(context).primaryColor,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_outlined,
              color: Color(0xff334155),
              size: 28,
            ),
            title: const BodyTextComponent(
              text: 'Apagar Conta',
            ),
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) => const AlertDialogComponent(
                  statusType: 'error',
                  title: 'Excluir Conta',
                  message:
                      'A conta será apagada e todos os dados serão perdidos. Deseja continuar?',
                ),
              ).then((value) async {
                if (value) {
                  LoadingModalComponent loadingModalComponent =
                      LoadingModalComponent();
                  loadingModalComponent.showModal(context);
                  await userProfileFirebaseService
                      .deleteUserProfile(_idUser.value);
                  await auth.deleteAccount(_idUser.value);
                  auth.signOut();
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.pushReplacementNamed(
                      context, LoginScreen.routeName);
                }
              });
            },
            selectedTileColor: Theme.of(context).primaryColor,
          ),
          ListTile(
            leading: const Icon(
              Icons.info_outline,
              color: Color(0xff334155),
              size: 28,
            ),
            title: const BodyTextComponent(
              text: 'Sobre',
            ),
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
            selectedTileColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  selectAction(int index) {
    setState(() {
      widget.selectIndex = index;
    });
  }
}
