import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/payment/controllers/order_controller.dart';
import 'package:etechstore/module/product_detail/model/discount_model.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:etechstore/module/product_detail/model/product_sample_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../orders/model/detail_orders.dart';

class ProductController extends GetxController {
   ProductController get instance => Get.find();
  final CartController cartController = Get.put(CartController());
  OrderController ordersController = Get.put(OrderController());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   var products = <ProductModel>[].obs;
  var currentIndex = 1.obs;
  var allDiscount = <DiscountModel>[].obs;
  final discount = <DiscountModel>[].obs;

  void setCurrentIndex(int index) {
    currentIndex.value = index;
  }

  void resetIndex() {
    currentIndex.value = 0;
  }

  Stream<List<DiscountModel>> getDiscount() {
    return _firestore.collection('KhuyenMai').orderBy('NgayBD', descending: true).snapshots().map((query) {
      discount.value = query.docs.map((doc) => DiscountModel.fromJson(doc.data())).toList();
      allDiscount.value = discount;
      return discount;
    });
  }
}
