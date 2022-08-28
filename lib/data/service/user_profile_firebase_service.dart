import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileFirebaseService {
  createUserProfile(String userId, Map<String, dynamic> user) async {
    // TODO
    final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
    await docUser.set(user);
  }

  deleteUserProfile(String userId) {
    // TODO
    final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
    docUser.delete();
  }
}
