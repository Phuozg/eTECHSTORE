import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/profile/views/edit_views/profile_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget address(String userID){
  return Container(
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Colors.white,
    boxShadow: const [
      BoxShadow(color: Color(0xFF383CA0), spreadRadius: 1),
    ],
  ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(userID)
              .snapshots(),
        builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return  const CircularProgressIndicator();
        }
        var document = snapshot.data;
        return  GestureDetector(
          onTap: (){
            Get.to(EditProfileScreen());
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined),
                      Text("Địa chỉ nhận hàng",style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Icon(Icons.settings)
                ],
              ),
              Text(document?["HoTen"]+" | ${document?["SoDienThoai"]}"),
              Text(document?["DiaChi"]),
            ],
          ),
        );
           }
        ),
    ),
  );
}