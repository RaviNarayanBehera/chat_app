import 'dart:developer';

import 'package:chat_app/model/chat_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';

class CloudFireStoreService {
  CloudFireStoreService._();

  static CloudFireStoreService cloudFireStoreService =
  CloudFireStoreService._();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // collection->doc->set -update/add : doc,id unique : new data , same - replace;
  // collection->add() unique doc.id data add in fire store

  Future<void> insertUserIntoFireStore(UserModel user) async {
    await firestore.collection("users").doc(user.email).set({
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'token': user.token,
      'image': user.image,
    });
  }

  // Read data for current user - profile
  Future<DocumentSnapshot<Map<String, dynamic>>>
  readCurrentUserFromFireStore() async {
    User? user = AuthService.authService.getCurrentUser();
    return await firestore.collection("users").doc(user!.email).get();
  }

  // Read all user from fire Store
  Future<QuerySnapshot<Map<String, dynamic>>>
  readAllUserFromCloudFireStore() async {
    User? user = AuthService.authService.getCurrentUser();
    return await firestore
        .collection('users')
        .where("email", isNotEqualTo: user!.email)
        .get();
  }

  // Add chat in FireStore
  Future<void> addChatInFireStore(ChatModel chat) async {
    String? sender = chat.sender;
    String? receiver = chat.receiver;
    List doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");

    await firestore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .add(chat.toMap(chat));
  }

  // Read chat from fireStore
  Stream<QuerySnapshot<Map<String, dynamic>>> readChatFromFireStore(
      String receiver) {
    String sender = AuthService.authService.getCurrentUser()!.email!;
    List doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");
    return firestore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .orderBy("time", descending: false)
        .snapshots();
  }

  Future<void> updateChat(String receiver, String message, String dcId) async {
    String sender = AuthService.authService.getCurrentUser()!.email!;
    List doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");
    await firestore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .doc(dcId)
        .update({
      'message': message,
    });
  }

  Future<void> removeChat(String dcId, String receiver) async {
    String sender = AuthService.authService.getCurrentUser()!.email!;
    List doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");
    await firestore.collection("chatroom").doc(docId).collection("chat").doc(
        dcId).delete();
  }

  Future<void> changeOnlineStatus(bool status) async {
    String email = AuthService.authService.getCurrentUser()!.email!;

    await firestore.collection("users").doc(email).update({
      'isOnline': status
    });
    
    final snapshot = await firestore.collection("users").doc(email).get();
    Map? user = snapshot.data();
    log("user online status after $status : ${user!['isOnline']}");
  }

  // find user is online or not

  Stream<DocumentSnapshot<Map<String, dynamic>>> findUserIsOnlineOrNot(String email)
  {
    // String email = AuthService.authService.getCurrentUser()!.email!;
    return firestore.collection("users").doc(email).snapshots();
  }

}

// Collection : is a collection of multiple documents
// Document : Document hold a information(Data - Map) or collection
