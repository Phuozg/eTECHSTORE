import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:etechstore/module/chat_with_admin/controller/chat_controller.dart';
import 'package:etechstore/module/chat_with_admin/view/chat_screen.dart';
import 'package:etechstore/module/chat_with_admin/view/widget/user_title.dart';
import 'package:etechstore/services/auth/auth_services.dart';
import 'package:etechstore/services/chat/chat_services.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class ChatHomePageScreen extends GetView {
  ChatHomePageScreen({super.key});

  final chatServices = ChatServices();
  final authServices = AuthServices();

  @override
  final controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ('Chat'),
        ),
        centerTitle: true,
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: chatServices.getUserStream(),
      builder: (context, snapshot) {
//Error
        if (snapshot.hasError) {
          return const Text("Error");
        }
//Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        return ListView(
          children: snapshot.data!.map<Widget>((userData) => _BuildUserListItem(userData, context)).toList(),
        );
      },
    );
  }

  Widget _BuildUserListItem(Map<String, dynamic> userData, BuildContext context,) {
    
    if (userData["email"] != authServices.getCurrentUser()!.email) {
      return UserTitle(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            )),
        text: userData['HoTen'],
      );
    } else {
      return Container();
    }
  }
}
