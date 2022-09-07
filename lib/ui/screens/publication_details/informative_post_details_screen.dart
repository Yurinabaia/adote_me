import 'package:adoteme/data/service/animal_publication_service.dart';
import 'package:adoteme/data/service/informative_publication_service.dart';
import 'package:adoteme/ui/components/alert_dialog_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/ui/screens/publication_details/components/carousel_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_launcher/link.dart';

class InformativePostDetailsScreen extends StatefulWidget {
  static const routeName = "/informative_post_details";

  const InformativePostDetailsScreen({super.key});

  @override
  State<InformativePostDetailsScreen> createState() => _InformativePostDetailsScreenState();
}

class _InformativePostDetailsScreenState extends State<InformativePostDetailsScreen> {
  String? title;
  String? description;
  String? url;
  String? date;

  List<String?> _listImagesCarousel = [];

  @override
  void initState() {
    super.initState();
    startData();
  }

  void startData() async {
    initializeDateFormatting('pt-br');

    var dataPublication = await InformativePublicationService.getInformativePublication('VvbV8RJzoUxypotJYxGi');
    if (dataPublication.data() != null) {
      setState(() {
        _listImagesCarousel = List<String>.from(dataPublication.data()?['listImages']);
        title = dataPublication.data()!['title'];
        description = dataPublication.data()!['description'];
        url = dataPublication.data()!['url'];

        var timestamp = dataPublication.data()?['updatedAt'] ?? dataPublication.data()?['createdAt'];
        var dateTime = DateTime.fromMicrosecondsSinceEpoch(timestamp!.microsecondsSinceEpoch);
        date = '${DateFormat.yMMMMEEEEd('pt-br').format(dateTime)}    ${DateFormat.jms('pt-br').format(dateTime)}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          // TODO: falta implementar o card em 'Minhas publicações para editar'
          // Navigator.of(context).pushNamed('/create-publication/basic_animal_data')
          onPressed: () => {},
          child: const Icon(
            Icons.edit,
            size: 40,
          ),
        ),
      ),
      body: NestedScrollView(
        scrollBehavior: const ScrollBehavior(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              shadowColor: Colors.transparent,
              leading: Align(
                alignment: const Alignment(0.2, 0.2),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Color(0xff334155),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              flexibleSpace: _listImagesCarousel.isNotEmpty
                  ? FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CarouselComponent(
                              listImages: _listImagesCarousel,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      alignment: const AlignmentDirectional(0, 0.55),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 73, 73, 73),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, -6),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Publicação Informativa',
                        style: TextStyle(
                          color: Color(0xff334155),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
              expandedHeight: _listImagesCarousel.isNotEmpty ? 310.0 : 56,
              collapsedHeight: _listImagesCarousel.isNotEmpty ? 310.0 : 56,
            )
          ];
        },
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$title",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff334155),
                        ),
                      ),
                      DetailTextComponent(
                        text: "$date",
                      ),
                      const SizedBox(height: 32),
                      const TitleThreeComponent(text: "Descrição"),
                      DetailTextComponent(
                        text: "$description",
                      ),
                      const SizedBox(height: 32),
                      if (url != null) ...[
                        // const TitleThreeComponent(text: 'Acesse para ver mais'),
                        Link(
                          uri: Uri.parse(url!),
                          target: LinkTarget.blank,
                          builder: (BuildContext ctx, FollowLink? openLink) {
                            return TextButton.icon(
                              onPressed: openLink,
                              label: Text(
                                'Acesse para ver mais ',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              icon: SvgPicture.asset(
                                'assets/images/external-link.svg',
                                width: 20,
                                color: const Color(0xff4090CE),
                                height: 20,
                              ),
                            );
                          },
                        ),
                        // Text(
                        //   '$url',
                        //   style: const TextStyle(
                        //     color: Colors.blue,
                        //     decoration: TextDecoration.underline,
                        //   ),
                        // ),
                      ],
                      const SizedBox(height: 64),
                      ButtonComponent(
                        text: 'Excluir publicação',
                        color: const Color(0xffA82525),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => const AlertDialogComponent(
                              statusType: 'error',
                              title: 'Excluir publicação',
                              message: 'A publicação será excluída permanentemente. Deseja prosseguir ?',
                            ),
                          ).then((value) {
                            if (value) {
                              InformativePublicationService.deleteInformativePublication("VvbV8RJzoUxypotJYxGi");
                              Navigator.pushReplacementNamed(context, '/my_publications');
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}