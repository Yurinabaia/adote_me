import 'package:adoteme/data/providers/id_publication_provider.dart';
import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/data/service/publication_service.dart';
import 'package:adoteme/data/service/user_profile_firebase_service.dart';
import 'package:adoteme/ui/components/alert_dialog_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/ui/screens/publication_details/components/carousel_component.dart';
import 'package:adoteme/ui/screens/publication_details/components/check_favorite_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

class InformativePostDetailsScreen extends StatefulWidget {
  static const routeName = "/informative_post_details";

  const InformativePostDetailsScreen({super.key});

  @override
  State<InformativePostDetailsScreen> createState() =>
      _InformativePostDetailsScreenState();
}

class _InformativePostDetailsScreenState
    extends State<InformativePostDetailsScreen> {
  String? title;
  String? description;
  String? url;
  String? date;
  bool _isSelected = false;
  bool _isMyPublication = false;

  List<String?> _listImagesCarousel = [];
  List<String> _listFavoritesFirebase = [];

  final ValueNotifier<String?> _idPublicationNotifier =
      ValueNotifier<String?>(null);
  final ValueNotifier<String?> _idUserNotifier = ValueNotifier<String?>(null);
  final UserProfileFirebaseService userService = UserProfileFirebaseService();

  @override
  void initState() {
    final idPublicationProvider = context.read<IdPublicationProvider>();
    _idPublicationNotifier.value = idPublicationProvider.get();
    final auth = context.read<LoginFirebaseService>();
    _idUserNotifier.value = auth.idFirebase();
    if (_idPublicationNotifier.value != null) {
      startData();
    }
    super.initState();
  }

  getFavoriteUser() async {
    DocumentSnapshot<Map<String, dynamic>> dataUser =
        await userService.getUserProfile(_idUserNotifier.value!);
    if (dataUser.data() != null) {
      setState(() {
        _listFavoritesFirebase =
            List<String>.from(dataUser.data()?['listFavoritesInformative']);
        _isSelected =
            _listFavoritesFirebase.contains(_idPublicationNotifier.value);
      });
    }
  }

  void startData() async {
    initializeDateFormatting('pt-br');

    var dataPublication = await PublicationService.getPublication(
        _idPublicationNotifier.value!, 'informative_publication');
    if (dataPublication?.data() != null) {
      setState(() {
        _isMyPublication =
            dataPublication?.data()?['idUser'] == _idUserNotifier.value;
        if (!_isMyPublication) {
          getFavoriteUser();
        }

        _listImagesCarousel =
            List<String>.from(dataPublication?.data()?['listImages']);
        title = dataPublication?.data()!['title'];
        description = dataPublication?.data()!['description'];
        url = dataPublication?.data()!['url'];

        var timestamp = dataPublication?.data()?['updatedAt'];
        var dateTime = DateTime.fromMicrosecondsSinceEpoch(
            timestamp!.microsecondsSinceEpoch);
        date =
            '${DateFormat.yMMMMEEEEd('pt-br').format(dateTime)}    ${DateFormat.jms('pt-br').format(dateTime)}';
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
          onPressed: () => {
            Navigator.pushNamed(
                context, '/create-publication/informative_publication')
          },
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
                      final arguments =
                          ModalRoute.of(context)?.settings.arguments;

                      if (arguments != null) {
                        Navigator.pushReplacementNamed(context, '/favorites');
                      } else {
                        Navigator.pop(context);
                      }
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
                              status: null,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: DetailTextComponent(
                              text: "$date",
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          if (!_isMyPublication)
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isSelected = !_isSelected;
                                    _listFavoritesFirebase.contains(
                                            _idPublicationNotifier.value)
                                        ? _listFavoritesFirebase.remove(
                                            _idPublicationNotifier.value)
                                        : _listFavoritesFirebase
                                            .add(_idPublicationNotifier.value!);

                                    Map<String, dynamic> data = {
                                      'listFavoritesInformative':
                                          _listFavoritesFirebase
                                    };
                                    userService.updateProfile(
                                        _idUserNotifier.value, data);
                                  });
                                },
                                child: CheckFavoriteComponent(
                                    isChecked: _isSelected)),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const TitleThreeComponent(text: "Descrição"),
                      DetailTextComponent(
                        text: "$description",
                      ),
                      const SizedBox(height: 32),
                      if (url != null)
                        Link(
                          uri: Uri.parse(url!),
                          target: LinkTarget.blank,
                          builder: (BuildContext ctx, FollowLink? openLink) {
                            return TextButton.icon(
                              onPressed: openLink,
                              label: const Text(
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
                              message:
                                  'A publicação será excluída permanentemente. Deseja prosseguir ?',
                            ),
                          ).then((value) {
                            if (value) {
                              PublicationService.deletePublication(
                                  _idPublicationNotifier.value!,
                                  'informative_publication');
                              Navigator.pushReplacementNamed(
                                  context, '/my_publications');
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
