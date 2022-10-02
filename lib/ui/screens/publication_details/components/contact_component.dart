import 'package:adoteme/ui/components/texts/label_text_component.dart';
import 'package:adoteme/utils/contact_open.dart';
import 'package:flutter/material.dart';

class ContactComponent extends StatelessWidget {
  final String? userName;
  final String? userPhone;
  final String? userPhoto;
  final String typePhone;
  final String nameAnimal;
  ContactComponent({
    Key? key,
    required this.userName,
    required this.userPhone,
    required this.userPhoto,
    required this.typePhone,
    this.nameAnimal = "Animal",
  }) : super(key: key);
  final ContactOpen contactOpen = ContactOpen();
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
        onTap: () {
          String phone = userPhone!.replaceAll(RegExp(r'[^0-9]'), '');
          if (typePhone == "WhatsApp") {
            contactOpen.openWhatsApp(phone, nameAnimal);
          } else if (typePhone == "Telefone") {
            contactOpen.openCall(phone);
          }
        },
      ),
    );
  }
}
