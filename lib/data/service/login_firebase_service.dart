// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class LoginFirebaseService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException {
      rethrow;
    }
    return null;
  }

  Future<void> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance
          .login(permissions: (['email', 'public_profile']));
      final token = result.accessToken!.token;
      final graphResponse = await http.get(Uri.parse(
          'https://graph.facebook.com/'
          'v2.12/me?fields=name,first_name,last_name,email&access_token=$token'));
      final profile = jsonDecode(graphResponse.body);
      try {
        final AuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        final userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookCredential);
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      return false;
    }
    return true;
  }

  Future<String?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'A senha fornecida é muito fraca';
      } else if (e.code == 'email-already-in-use') {
        return 'Essa conta já está em uso';
      }
    }
    return null;
  }

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<bool> isEmailVerified() async {
    try {
      await _auth.currentUser!.reload();
    } on FirebaseAuthException {
      return false;
    }
    return _auth.currentUser!.emailVerified;
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      return false;
    }
    return true;
  }

  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
      await FacebookAuth.instance.logOut();
    } catch (e) {
      rethrow;
    }
  }

  clearAuth() {
    try {
      _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAccount(String idUser) async {
    try {
      await deletePublication("informative_publication", idUser);
      await deletePublication("publications_animal", idUser);
      await _auth.currentUser?.delete();
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deletePublication(
      String collection, String idUser) async {
    try {
      final docPublication = await FirebaseFirestore.instance
          .collection(collection)
          .where('idUser', isEqualTo: idUser)
          .get();
      if (collection != "informative_publication" &&
          docPublication.docs.isNotEmpty) {
        for (var element in docPublication.docChanges) {
          if (element.doc.data()?['animalPhotos'] != null) {
            for (var photo in element.doc.data()?['animalPhotos']) {
              await FirebaseStorage.instance.refFromURL(photo).delete();
            }
          }
          if (element.doc.data()?['picturesVaccineCard'] != null) {
            for (var photo in element.doc.data()?['picturesVaccineCard']) {
              await FirebaseStorage.instance.refFromURL(photo).delete();
            }
          }
          element.doc.reference.delete();
        }
      } else if (docPublication.docs.isNotEmpty) {
        for (var element in docPublication.docChanges) {
          if (element.doc.data()?['imageCover'] != null) {
            await FirebaseStorage.instance
                .refFromURL(element.doc.data()?['imageCover'])
                .delete();
          }
          if (element.doc.data()?['listImages'] != null) {
            for (var photo in element.doc.data()?['listImages']) {
              await FirebaseStorage.instance.refFromURL(photo).delete();
            }
          }
          element.doc.reference.delete();
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  String idFirebase() {
    final User? user = _auth.currentUser;
    return user == null ? '' : user.uid;
  }

  String emailFirebase() {
    final User? user = _auth.currentUser;
    return user == null ? '' : user.email!;
  }
}
