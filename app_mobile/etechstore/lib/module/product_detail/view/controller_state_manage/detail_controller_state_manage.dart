import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/product_detail/controller/get_product_controller.dart';
import 'package:etechstore/module/product_detail/model/product_detail_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  List<dynamic> slides = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getImages();
  }

  Future<void> getImages() async {
    FirebaseFirestore.instance.collection('SanPham').doc('84yY8W43xohqr0CDpzj6').get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        slides = (data['HinhAnh']);
        // Sử dụng myList
        print(slides.length);
      } else {
        print('Document does not exist');
      }
    });
  }
}
