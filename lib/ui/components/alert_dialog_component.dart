import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlertDialogComponent extends StatefulWidget {
  final String statusType;
  final String title;
  final String message;
  const AlertDialogComponent(
      {super.key,
      required this.statusType,
      required this.title,
      required this.message});

  @override
  State<AlertDialogComponent> createState() => _AlertDialogComponentState();
}

class _AlertDialogComponentState extends State<AlertDialogComponent> {
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
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: <Widget>[
          SvgPicture.asset(
            status[widget.statusType]['icon'],
          ),
          const SizedBox(width: 8),
          Text(
            widget.title,
            style: TextStyle(
              color: status[widget.statusType]['color'],
            ),
          ),
        ],
      ),
      content: Text(
        widget.message,
        style: const TextStyle(
          color: Color(0xff334155),
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: status[widget.statusType]['color'],
            side: BorderSide(
              color: status[widget.statusType]['color'],
            ),
          ),
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: status[widget.statusType]['color'],
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
