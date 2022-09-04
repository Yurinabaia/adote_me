import 'package:adoteme/ui/components/texts/label_text_component.dart';
import 'package:flutter/material.dart';

class ContactComponent extends StatelessWidget {
  const ContactComponent({Key? key}) : super(key: key);

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
            backgroundImage: Image.network(
              'https://picsum.photos/300',
            ).image,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xff6D8DAD),
        ),
        title: const Text(
          'Michael Jackson',
          style: TextStyle(
            color: Color(0xff334155),
            fontSize: 18,
          ),
        ),
        subtitle: const LabelTextComponent(
          text: '(31) 99999-9999',
        ),
        // TODO: Implementar ação de contato
        onTap: () {},
      ),
    );
  }
}
