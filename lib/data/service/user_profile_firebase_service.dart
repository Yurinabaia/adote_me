import 'package:adoteme/data/service/address/calculate_distance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserProfileFirebaseService extends ChangeNotifier {
  bool isExecute;
  UserProfileFirebaseService({this.isExecute = false});

  Future<bool> saveUserProfile(String userId, Map<String, dynamic> user) async {
    String addressUser = "${user['street']} ${user['number']}, ${user['city']}";
    Map<dynamic, dynamic> latLongUser =
        await CalculateDistance.addressCordenate(addressUser);
    user.addAll({
      'lat': latLongUser['lat'],
      'long': latLongUser['long'],
    });

    final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
    try {
      await docUser.set(user);
      isExecute = true;
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> updateProfile(
      String? userId, Map<String, dynamic> dataUser) async {
    if (dataUser['street'] != null) {
      String addressUser =
          "${dataUser['street']} ${dataUser['number']}, ${dataUser['city']}";
      Map<dynamic, dynamic> latLongUser =
          await CalculateDistance.addressCordenate(addressUser);
      dataUser.addAll({
        'lat': latLongUser['lat'],
        'long': latLongUser['long'],
      });
    }
    final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
    try {
      await docUser.update(dataUser);
      isExecute = true;
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }

  void deleteUserProfile(String userId) {
    final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
    docUser.delete();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile(
      String userId) async {
    try {
      final docUser =
          FirebaseFirestore.instance.collection('users').doc(userId);
      return await docUser.get();
    } catch (e) {
      rethrow;
    }
  }
}
