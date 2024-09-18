import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/cloud_firestore_service.dart';
import 'package:chat_app/services/google_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: FutureBuilder(
          future: CloudFireStoreService.cloudFireStoreService
              .readCurrentUserFromFireStore(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            Map? data = snapshot.data!.data();
            UserModel userModel = UserModel.fromMap(data!);
            return Column(
              children: [
                DrawerHeader(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(userModel.image!),
                    radius: 50,
                  ),
                ),
                Text((userModel.name!)),
                Text((userModel.email!)),
                Text((userModel.phone!)),
              ],
            );
          },
        ),
      ),
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService.authService.signOutUser();
              await GoogleAuthService.googleAuthService.signOutFromGoogle();
              User? user = AuthService.authService.getCurrentUser();
              if (user == null) {
                Get.offAndToNamed('/signIn');
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder(
        future: CloudFireStoreService.cloudFireStoreService
            .readAllUserFromCloudFireStore(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List data = snapshot.data!.docs;
          List<UserModel> userList = [];
          for(var user in data)
            {
              userList.add(UserModel.fromMap(user.data()));
            }
          return ListView.builder(itemCount: userList.length,itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(userList[index].image!),),
              title: Text(userList[index].name!),
              subtitle: Text(userList[index].email!),
            );
          },);
        },
      ),
    );
  }
}

// 12.22

// keytool -list -v -alias androiddebugkey -keystore C:\Users\RAVINARAYAN\.android\debug.keystore
