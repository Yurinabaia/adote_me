import 'package:url_launcher/url_launcher.dart';

class ContactOpen {
  openWhatsApp(String phone, String? nameAnimal) async {
    var messengerUrl = Uri.parse(
        'whatsapp://send?phone=+55$phone&text=Olá encontrei o anuncio do $nameAnimal no aplicaitvo Adote Animal!');
    if (await canLaunchUrl(messengerUrl)) {
      await launchUrl(messengerUrl);
    } else {
      throw 'Could not launch $messengerUrl';
    }
  }

  openWhatsAppDevelop(String phone) async {
    var messengerUrl = Uri.parse(
        'whatsapp://send?phone=+55$phone&text=Olá encontrei o seu contato no aplicaitvo Adote Animal!');
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

  openBrowser(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  openGoogleMaps(String lat, String long) async {
    var mapsUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (await canLaunchUrl(Uri.parse(mapsUrl))) {
      await launchUrl(Uri.parse(mapsUrl));
    } else {
      throw 'Could not launch $mapsUrl';
    }
  }
}
