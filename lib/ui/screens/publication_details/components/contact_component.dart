import 'package:adoteme/ui/components/texts/label_text_component.dart';
import 'package:flutter/material.dart';

class ContactComponent extends StatelessWidget {
  final String? userName;
  final String? userPhone;
  final String? userPhoto;

  const ContactComponent({
    Key? key,
    required this.userName,
    required this.userPhone,
    required this.userPhoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(10.0),
      shadowColor: const Color(0xff6D8DAD),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: SizedBox(
          height: 100,
          width: 50,
          child: CircleAvatar(
            backgroundImage: userPhoto != null
                ? Image.network(
                    '$userPhoto',
                  ).image
                : Image.asset(
                    'assets/images/user_profile.png',
            ).image,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xff6D8DAD),
        ),
        title: Text(
          '$userName',
          style: const TextStyle(
            color: Color(0xff334155),
            fontSize: 18,
          ),
        ),
        subtitle: LabelTextComponent(
          text: '$userPhone',
        ),
        // TODO: Implementar ação de contato
        onTap: () {},
      ),
    );
  }
}
