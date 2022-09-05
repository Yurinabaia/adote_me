import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlertDialogComponent {
  final String statusType;
  final String title;
  final String message;

  AlertDialogComponent({
    required this.statusType,
    required this.title,
    required this.message,
  });

  Map status = {
    'success': {
      'icon': 'assets/images/check.svg',
      'color': const Color(0xff21725E),
    },
    'error': {
      'icon': 'assets/images/error.svg',
      'color': const Color(0xffA82525),
    },
    // 'warning': {
    //   'icon': 'assets/images/warning.svg',
    //   'color': const Color(0xffFBC224),
    // },
    // 'info': {
    //   'icon': 'assets/images/info.svg',
    //   'color': const Color(0xff2789E3),
    // },
  };

  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          children: <Widget>[
            SvgPicture.asset(
              status[statusType]['icon'],
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: status[statusType]['color'],
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Color(0xff334155),
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              primary: status[statusType]['color'],
              side: BorderSide(
                color: status[statusType]['color'],
              ),
            ),
            onPressed: () => {
              Navigator.of(context).pop(),
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: status[statusType]['color'],
            ),
            // TODO: Implementar ação do botão
            onPressed: () => {},
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
