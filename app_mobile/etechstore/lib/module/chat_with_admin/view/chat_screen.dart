import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/chat_with_admin/view/chat_burble_screen.dart';
import 'package:etechstore/services/auth/auth_services.dart';
import 'package:etechstore/services/chat/chat_services.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  final AuthServices authServices = AuthServices();
  final ChatServices chatServices = ChatServices();
  final TextEditingController _messageController = TextEditingController();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await chatServices.sendMessage(receiverID, _messageController.text);

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buiUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = authServices.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: chatServices.getMessges(receiverID, senderID),
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
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['id'] == authServices.getCurrentUser()!.uid;
    //aligment
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(message: data["NoiDung"], isCurrentUser: isCurrentUser),
          ],
        ));
  }

  Widget _buiUserInput() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0, left: 10),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: TTexts.guiTinNhan,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
              controller: _messageController,
              obscureText: false,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          margin: const EdgeInsets.only(right: 25),
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: IconButton(
              onPressed: () {
                sendMessage();
              },
              icon: const Icon(
                Icons.arrow_upward,
              )),
        )
      ],
    );
  }
}
