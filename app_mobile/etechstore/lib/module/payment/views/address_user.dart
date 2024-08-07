import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/profile/controller/profile_controller.dart';
import 'package:etechstore/module/profile/views/edit_views/profile_edit_screen.dart';
import 'package:etechstore/module/profile/views/edit_views/widget/edit_profile_widget.dart';
import 'package:etechstore/module/profile/views/edit_views/widget/profile_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget address(String userID) {
  final ProfileController profileController = Get.put(ProfileController());

  return Container(
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      border: Border.all(width: 1,color:const Color(0xFF383CA0) ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Users').doc(userID).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            var document = snapshot.data;
            return GestureDetector(
              onTap: () {
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
                          Text(
                            "Địa chỉ nhận hàng",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Icon(Icons.settings)
                    ],
                  ),
                  Text(document?["HoTen"] + " | 0${document?["SoDienThoai"]}"),
                  Text(document?["DiaChi"]),
                ],
              ),
            );
          }),
    ),
  );
}
