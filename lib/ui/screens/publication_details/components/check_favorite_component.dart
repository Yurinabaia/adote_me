import 'package:flutter/material.dart';

class CheckFavoriteComponent extends StatelessWidget {
  final bool isChecked;
  const CheckFavoriteComponent({super.key, required this.isChecked});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastLinearToSlowEaseIn,
      decoration: BoxDecoration(
        color: isChecked ? const Color(0xffEE8362) : Colors.grey[350],
        borderRadius: BorderRadius.circular(50),
      ),
      width: 50,
      height: 50,
      child: const Icon(
        Icons.favorite,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
