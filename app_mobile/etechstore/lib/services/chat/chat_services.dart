import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/chat_with_admin/model/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return firestore.collection("Users").where('Quyen',isEqualTo: '1').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          final user = doc.data();
          return user;
        }).toList();
      },
    );
  }

  //send message
  Future<void> sendMessage(String receiverID, message) async {
    final String currentUserID = firebaseAuth.currentUser!.uid;
    final String currentUserEmail = firebaseAuth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create new message
    Message newMessage = Message(
      maKhachHang: currentUserEmail,
      trangThai: receiverID,
      noiDung: message,
      thoiGianNhan: timestamp,
      id: currentUserID,
    );
//
    List<String> ids = [receiverID, currentUserID];
//
    ids.sort();
    String chatRoomID = ids.join('_');
    //add new message DB
    await firestore.collection('Chat').doc(chatRoomID).collection('NoiDung').add(newMessage.json());
  }

  // get message
  Stream<QuerySnapshot> getMessges(String userID, String ortherUserID) {
    List<String> ids = [userID, ortherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return firestore.collection('Chat').doc(chatRoomID).collection('NoiDung').orderBy('ThoiGianNhan', descending: false).snapshots();
  }
}
