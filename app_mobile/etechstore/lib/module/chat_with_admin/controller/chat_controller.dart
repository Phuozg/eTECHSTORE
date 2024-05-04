import 'dart:ffi';

import 'package:etechstore/services/auth/auth_services.dart';
import 'package:etechstore/services/chat/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  static ChatController get instance => Get.find();

  //Services
  final AuthServices authServices = AuthServices();
  final ChatServices chatServices = ChatServices();

  //TextEditingController
  final TextEditingController messageController = TextEditingController();

  //variable
  RxString receiverID = ''.obs;
  RxString userID = ''.obs;
  RxString ortherUserID = ''.obs;

  void getMessages() {
    chatServices.getMessges(userID.value, ortherUserID.value);
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatServices.sendMessage(receiverID.value, messageController.text);

      messageController.clear();
    }
  }
}
