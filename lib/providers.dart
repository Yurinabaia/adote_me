import 'package:adoteme/data/models/publication_model.dart';
import 'package:adoteme/data/providers/form_key_provider.dart';
import 'package:adoteme/data/providers/id_publication_provider.dart';
import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/data/service/user_profile_firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final providers = <SingleChildWidget>[
  ChangeNotifierProvider<LoginFirebaseService>(
    create: (context) => LoginFirebaseService(),
  ),
  ChangeNotifierProvider<UserProfileFirebaseService>(
    create: (context) => UserProfileFirebaseService(),
  ),
  ChangeNotifierProvider<FormKeyProvider>(
    create: (context) => FormKeyProvider(GlobalKey<FormState>()),
  ),
  ChangeNotifierProvider<PublicationModel>(
    create: (context) => PublicationModel(),
  ),
  ChangeNotifierProvider<IdPublicationProvider>(
    create: (context) => IdPublicationProvider(null),
  ),
];
