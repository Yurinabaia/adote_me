import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final providers = <SingleChildWidget>[
  ChangeNotifierProvider<FirebaseService>(
    create: (context) => FirebaseService(),
  ),
];
