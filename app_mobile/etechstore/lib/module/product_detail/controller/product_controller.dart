import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/payment/controllers/order_controller.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:etechstore/module/product_detail/model/product_sample_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../orders/model/detail_orders.dart';

class ProductController extends GetxController {
  final firestore = FirebaseFirestore.instance;
  ProductController get instance => Get.find();
  final CartController cartController = Get.put(CartController());
  OrderController ordersController = Get.put(OrderController());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var productSamples = <ProductSampleModel>[].obs;
  var products = <ProductModel>[].obs;
  var currentIndex = 1.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void setCurrentIndex(int index) {
    currentIndex.value = index;
  }

  void resetIndex() {
    currentIndex.value = 0;
  }

 
}
