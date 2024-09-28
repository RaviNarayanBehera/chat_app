import 'package:chat_app/services/cloud_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ChatController extends GetxController
{
  RxString receiverEmail = "".obs;
  RxString receiverName = "".obs;
  TextEditingController txtMessage = TextEditingController();
  TextEditingController txtUpdateMessage = TextEditingController();


  void getReceiver(String email,String name)
  {
    receiverEmail.value = email;
    receiverName.value = name;
  }

  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //   CloudFireStoreService.cloudFireStoreService.changeOnlineStatus(true);
  // }
  //
  // @override
  // void onClose() {
  //   // TODO: implement onClose
  //   super.onClose();
  //   CloudFireStoreService.cloudFireStoreService.changeOnlineStatus(false);
  //
  // }


}