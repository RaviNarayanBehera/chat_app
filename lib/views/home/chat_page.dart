import 'package:chat_app/model/chat_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/cloud_firestore_service.dart';
import 'package:chat_app/services/local_notification_service.dart';
import 'package:chat_app/services/storage_service.dart';
import 'package:chat_app/views/home/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
      appBar: AppBar(
        flexibleSpace: Container(
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
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatController.receiverName.value,
                  style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5),
                ),
                StreamBuilder(
                  stream: CloudFireStoreService.cloudFireStoreService
                      .findUserIsOnlineOrNot(
                          chatController.receiverEmail.value),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Text('User status unavailable');
                    }

                    Map? user = snapshot.data!.data();
                    if(user == null || user['isOnline']==null)
                      {
                        return const Text('User status unavailable');
                      }
                    return Text(
                      user!['isOnline'] ? 'Online' : '',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: themeController.isDarkMode.value
                ? [
                    const Color(0xff0c0f1e),
                    const Color(0xff210c1d),
                    const Color(0xff2b0a1b),
                    const Color(0xff33091d),
                  ]
                : [const Color(0xffcffbee), const Color(0xffcffbee)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: CloudFireStoreService.cloudFireStoreService
                      .readChatFromFireStore(
                          chatController.receiverEmail.value),
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
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(child: Text('No messages found.'));
                    }

                    List data = snapshot.data!.docs;
                    List<ChatModel> chatList = [];
                    List<String> docIdList = [];

                    for (QueryDocumentSnapshot snap in data) {
                      docIdList.add(snap.id);
                      chatList.add(ChatModel.fromMap(snap.data() as Map));
                    }

                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: List.generate(
                          chatList.length,
                          (index) => GestureDetector(
                            onLongPress: () {
                              if (chatList[index].sender ==
                                  AuthService.authService
                                      .getCurrentUser()!
                                      .email) {
                                chatController.txtUpdateMessage =
                                    TextEditingController(
                                        text: chatList[index].message);
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Update'),
                                      content: TextField(
                                        controller:
                                            chatController.txtUpdateMessage,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            String dcId = docIdList[index];

                                            CloudFireStoreService
                                                .cloudFireStoreService
                                                .updateChat(
                                                    chatController
                                                        .receiverEmail.value,
                                                    chatController
                                                        .txtUpdateMessage.text,
                                                    dcId);
                                            Get.back();
                                          },
                                          child: const Text('Update'),
                                        )
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            onDoubleTap: () {
                              if (chatList[index].sender ==
                                  AuthService.authService
                                      .getCurrentUser()!
                                      .email) {
                                CloudFireStoreService.cloudFireStoreService
                                    .removeChat(docIdList[index],
                                        chatController.receiverEmail.value);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              alignment: (chatList[index].sender ==
                                      AuthService.authService
                                          .getCurrentUser()!
                                          .email)
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                alignment: (chatList[index].sender ==
                                        AuthService.authService
                                            .getCurrentUser()!
                                            .email)
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: (chatList[index].sender ==
                                            AuthService.authService
                                                .getCurrentUser()!
                                                .email)
                                        ? (themeController.isDarkMode.value
                                            ? const Color(0xffa275e3)
                                            : const Color(0xff61fbf1))
                                        : (themeController.isDarkMode.value
                                            ? const Color(0xfffb0874)
                                            : const Color(0xff1ffbbb)),
                                  ),
                                  child: (chatList[index].image == "" && chatList[index].image!.isEmpty)
                                      ? Text(
                                    chatList[index].message!,
                                    style: TextStyle(
                                      fontSize: 15,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w500,
                                      color: (chatList[index].sender == AuthService.authService.getCurrentUser()!.email)
                                          ? (themeController.isDarkMode.value ? Colors.black : Colors.black)
                                          : (themeController.isDarkMode.value ? Colors.white : Colors.black87),
                                    ),
                                  )
                                      : Image.network(chatList[index].image!),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: chatController.txtMessage,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Colors.black,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () async {
                        String url = await StorageService.service.uploadImage();
                        chatController.getImage(url);
                      }, icon: const Icon(Icons.photo)),
                      IconButton(
                        onPressed: () async {
                          ChatModel chat = ChatModel(
                            image: chatController.image.value,
                              sender:
                                  AuthService.authService.getCurrentUser()!.email,
                              receiver: chatController.receiverEmail.value,
                              message: chatController.txtMessage.text,
                              time: Timestamp.now());

                          await CloudFireStoreService.cloudFireStoreService
                              .addChatInFireStore(chat);
                          await LocalNotificationService.notificationService.showNotification(AuthService.authService.getCurrentUser()!.email!, chatController.txtMessage.text);
                          chatController.txtMessage.clear();
                        },
                        icon: const Icon(
                          Icons.send_outlined,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
