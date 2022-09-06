import 'package:url_launcher/url_launcher.dart';

class ContactOpen {
  openWhatsApp(String phone) async {
    var messengerUrl = Uri.parse('whatsapp://send?phone=+55$phone&text=Olá ?');
    if (await canLaunchUrl(messengerUrl)) {
      await launchUrl(messengerUrl);
    } else {
      throw 'Could not launch $messengerUrl';
    }
  }

  openCall(String phone) async {
    final url = Uri(scheme: "tel", path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
