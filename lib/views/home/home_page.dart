import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../controller/chat_controller.dart';
import '../../main.dart';
import '../../model/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/cloud_firestore_service.dart';
import '../../services/google_auth_service.dart';
import '../../services/local_notification_service.dart';

var chatController = Get.put(ChatController());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    CloudFireStoreService.cloudFireStoreService.changeOnlineStatus(true);
  }

  @override
  void dispose() {
    super.dispose();
    CloudFireStoreService.cloudFireStoreService.changeOnlineStatus(false);
  }

  @override
  void deactivate() {
    super.deactivate();
    CloudFireStoreService.cloudFireStoreService.changeOnlineStatus(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
      drawer: Drawer(
        backgroundColor: Colors.tealAccent,
        child: FutureBuilder(
          future: CloudFireStoreService.cloudFireStoreService
              .readCurrentUserFromFireStore(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            Map? data = snapshot.data!.data();
            UserModel userModel = UserModel.fromMap(data!);
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: themeController.isDarkMode.value
                      ? [
                          Colors.purple.shade900,
                          Colors.purple.shade400,
                          Colors.pinkAccent.shade200,
                          Colors.pink
                        ]
                      : [const Color(0xff1ffbbb), const Color(0xff61fbf1)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
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
                            fontSize: 23,
                            letterSpacing: 1.5,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
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
                  ),
                  ListTile(
                    title: const Text('Theme',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    leading: Icon(
                      Theme.of(context).brightness == Brightness.dark
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      color: Colors.black,
                    ),
                    onTap: () {
                      themeController.toggleTheme();
                      Get.changeTheme(
                        themeController.isDarkMode.value
                            ? ThemeData.dark()
                            : ThemeData.light(),
                      );
                    },
                  ),
                  const ListTile(
                    title: Text(
                      'Help Center',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    leading: Icon(
                      Icons.help_center,
                      color: Colors.black,
                    ),
                  ),
                  const ListTile(
                    title: Text(
                      'Report a Problem',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    leading: Icon(
                      Icons.report,
                      color: Colors.black,
                    ),
                  ),
                  const ListTile(
                    title: Text(
                      'Privacy Policy',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    leading: Icon(
                      Icons.policy_outlined,
                      color: Colors.black,
                    ),
                  ),
                  const ListTile(
                    title: Text(
                      'Settings',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    leading: Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Chats',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        flexibleSpace: Obx(
          () => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: themeController.isDarkMode.value
                    ? [
                        Colors.purple.shade800,
                        Colors.purple.shade400,
                        Colors.pinkAccent.shade200,
                        Colors.pink
                      ]
                    : [const Color(0xff1ffbbb), const Color(0xff61fbf1)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
        ),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () async {
                await LocalNotificationService.notificationService
                    .scheduleNotification();
              },
              icon: Icon(
                Icons.notification_add_rounded,
                color: themeController.isDarkMode.value
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
          Obx(() => IconButton(
                onPressed: () async {
                  AuthService.authService.signOutUser();
                  await GoogleAuthService.googleAuthService.signOutFromGoogle();
                  User? user = AuthService.authService.getCurrentUser();
                  if (user == null) {
                    Get.offAndToNamed('/signIn');
                  }
                },
                icon: Icon(
                  Icons.logout_outlined,
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                ),
              )),
        ],
      ),
      body: FutureBuilder(
        future: CloudFireStoreService.cloudFireStoreService
            .readAllUserFromCloudFireStore(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          List data = snapshot.data!.docs;
          List<UserModel> userList = [];
          for (var user in data) {
            userList.add(UserModel.fromMap(user.data()));
          }
          return Obx(
            () => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: themeController.isDarkMode.value
                      ? [
                          Colors.purple.shade800,
                          Colors.purple.shade400,
                          Colors.pinkAccent.shade200,
                          Colors.pink
                        ]
                      : [const Color(0xff1ffbbb), const Color(0xff61fbf1)],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(userList.length, (index) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(userList[index].image!),
                                radius: 40,
                              ),
                            ),
                            Text(
                              userList[index].name!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: themeController.isDarkMode.value
                              ? [
                                  Colors.black,
                                  Colors.black54,
                                  Colors.pink.shade900,
                                  Colors.purple.shade700,
                                ]
                              : [
                                  const Color(0xffd3fbf2),
                                  const Color(0xffd3fbf2),
                                ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                        border: const Border(
                            top: BorderSide(color: Colors.black, width: 2)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 20),
                        child: ListView.builder(
                          itemCount: userList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                chatController.getReceiver(
                                    userList[index].email!,
                                    userList[index].name!);
                                Get.toNamed('/chat');
                              },
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(userList[index].image!),
                              ),
                              title: Text(
                                userList[index].name!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(userList[index].email!),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
