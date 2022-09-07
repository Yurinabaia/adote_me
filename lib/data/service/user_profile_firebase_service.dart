import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserProfileFirebaseService extends ChangeNotifier {
  bool isExecute;
  UserProfileFirebaseService({this.isExecute = false});

  Future<bool> saveUserProfile(String userId, Map<String, dynamic> user) async {
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
