import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/components/texts/body_text_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/utils/contact_open.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = "/about";
  final ContactOpen contactOpen = ContactOpen();
  AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarToBackComponent(
        title: "Sobre o aplicativo",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              const DetailTextComponent(
                text:
                    'O aplicativo Adote Animal foi desenvolvido para facilitar a adoção de animais de estimação, tanto para quem deseja adotar quanto para quem deseja doar, além de ajudar a divulgar os animais que estão perdidos e campanhas/dicas sobre animais.',
              ),
              const SizedBox(height: 20),
              const TitleThreeComponent(text: 'Desenvolvedores'),
              const SizedBox(height: 20),
              const BodyTextComponent(text: 'Lucas Luan dos Santos'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    child: SvgPicture.asset(
                      'assets/images/whatsapp_icon.svg',
                      height: 50,
                      width: 50,
                    ),
                    onTap: () => contactOpen.openWhatsAppDevelop('31992878615'),
                  ),
                  GestureDetector(
                    child: SvgPicture.asset(
                      'assets/images/linkedin_icon.svg',
                      height: 50,
                      width: 50,
                    ),
                    onTap: () => contactOpen.openBrowser(
                        'https://www.linkedin.com/in/lucas-luan-dos-santos/'),
                  ),
                  GestureDetector(
                    child: SvgPicture.asset(
                      'assets/images/github_icon.svg',
                      height: 50,
                      width: 50,
                    ),
                    onTap: () => contactOpen
                        .openBrowser('https://github.com/lucasluan01'),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              const BodyTextComponent(text: 'Yuri Nabaia Duarte'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    child: SvgPicture.asset(
                      'assets/images/whatsapp_icon.svg',
                      height: 50,
                      width: 50,
                    ),
                    onTap: () => contactOpen.openWhatsAppDevelop('31989616229'),
                  ),
                  GestureDetector(
                    child: SvgPicture.asset(
                      'assets/images/linkedin_icon.svg',
                      height: 50,
                      width: 50,
                    ),
                    onTap: () => contactOpen.openBrowser(
                        'https://www.linkedin.com/in/yuri-nabaia-530260143/'),
                  ),
                  GestureDetector(
                    child: SvgPicture.asset(
                      'assets/images/github_icon.svg',
                      height: 50,
                      width: 50,
                    ),
                    onTap: () => contactOpen
                        .openBrowser('https://github.com/Yurinabaia/'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
