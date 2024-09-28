import 'package:chat_app/controller/chat_controller.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/cloud_firestore_service.dart';
import 'package:chat_app/services/google_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

var chatController = Get.put(ChatController());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CloudFireStoreService.cloudFireStoreService.changeOnlineStatus(true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("------------------------Dispose----------------------");

    CloudFireStoreService.cloudFireStoreService.changeOnlineStatus(false);
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print("------------------------Deactivate----------------------");
    CloudFireStoreService.cloudFireStoreService.changeOnlineStatus(false);
  }

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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            Map? data = snapshot.data!.data();
            UserModel userModel = UserModel.fromMap(data!);
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.tealAccent.shade100,
                    Colors.tealAccent.shade200,
                    Colors.tealAccent.shade100,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DrawerHeader(
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(userModel.image!),
                          radius: 55,
                        ),
                      ),
                      Text(
                        userModel.name!,
                        style: const TextStyle(
                            fontSize: 20,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold),
                      ),
                      // SizedBox(height: 10,)
                    ],
                  ),
                  ListTile(
                    title: Text(userModel.email!,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    leading: const Icon(
                      Icons.email_outlined,
                      color: Colors.black,
                    ),
                    onTap: () {
                      // Do something
                    },
                  ),
                  ListTile(
                    title: Text(userModel.phone!,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    leading: const Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                    onTap: () {
                      // Do something
                    },
                  ),
                  ListTile(
                    title: const Text('Help Center',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    leading: const Icon(
                      Icons.help_center,
                      color: Colors.black,
                    ),
                    onTap: () {
                      // Do something
                    },
                  ),
                  ListTile(
                    title: const Text('Report a Problem',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    leading: const Icon(
                      Icons.report,
                      color: Colors.black,
                    ),
                    onTap: () {
                      // Do something
                    },
                  ),
                  ListTile(
                    title: const Text('Privacy Policy',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    leading: const Icon(
                      Icons.policy_outlined,
                      color: Colors.black,
                    ),
                    onTap: () {
                      // Do something
                    },
                  ),
                  ListTile(
                    title: const Text('Settings',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    leading: const Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                    onTap: () {
                      // Do something
                    },
                  ),
                  ListTile(
                    title: const Text('Log Out',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    onTap: () async {
                      await AuthService.authService.signOutUser();
                      await GoogleAuthService.googleAuthService
                          .signOutFromGoogle();
                      User? user = AuthService.authService.getCurrentUser();
                      if (user == null) {
                        Get.offAndToNamed('/signIn');
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      appBar: AppBar(
        title: const Text('Home Page'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.tealAccent.shade100,
                Colors.tealAccent.shade200,
                Colors.tealAccent.shade100,],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List data = snapshot.data!.docs;
          List<UserModel> userList = [];
          for (var user in data) {
            userList.add(UserModel.fromMap(user.data()));
          }
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.tealAccent.shade100,
                  Colors.tealAccent.shade200,
                  Colors.tealAccent.shade100,],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    chatController.getReceiver(
                        userList[index].email!, userList[index].name!);
                    Get.toNamed('/chat');
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userList[index].image!),
                  ),
                  title: Text(userList[index].name!),
                  subtitle: Text(userList[index].email!),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// 12.22

// keytool -list -v -alias androiddebugkey -keystore C:\Users\RAVINARAYAN\.android\debug.keystore
