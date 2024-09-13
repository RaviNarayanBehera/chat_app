
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class CloudFireStoreService
{
  CloudFireStoreService._();

  static CloudFireStoreService cloudFireStoreService = CloudFireStoreService._();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // collection->doc->set -update/add : doc,id unique : new data , same - replace;
  // collection->add() unique doc.id data add in fire store

  Future<void> insertUserIntoFireStore(UserModel user)
  async {
    await firestore.collection("users").doc(user.email).set({
      'name' : user.name,
      'email' : user.email,
      'phone' : user.phone,
      'token' : user.token,
      'image' : user.image,
    });
  }

}

// Collection : is a collection of multiple documents
// Document : Document hold a information(Data - Map) or collection