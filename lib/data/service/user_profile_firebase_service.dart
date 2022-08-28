import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileFirebaseService {
  Future<bool> saveUserProfile(String userId, Map<String, dynamic> user) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
    try {
      await docUser.set(user);
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
    final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
    return await docUser.get();
  }
}
