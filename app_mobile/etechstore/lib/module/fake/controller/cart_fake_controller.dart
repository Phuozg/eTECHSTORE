import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:etechstore/module/product_detail/model/product_sample_model.dart';
import 'package:get/get.dart';

class CartControllerFake extends GetxController {
  CartControllerFake get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var cartItem = <String, CartModel>{}.obs;
  var products = <String, ProductModel>{}.obs;

  var mauSanPham = <ProductSampleModel>[].obs;

  Stream<List<CartModel>> getCartItem() {
    return _firestore.collection('GioHang').snapshots().map((snapshot) => snapshot.docs.map((doc) => CartModel.fromMap(doc.data())).toList());
  }

  Stream<List<ProductSampleModel>> getCTDonHangs() {
    return _firestore
        .collection('MauSanPham')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ProductSampleModel.fromFirestore(doc.data())).toList());
  }

  Stream<List<ProductModel>> getProduct() {
    return _firestore.collection('SanPham').snapshots().map((snapshot) => snapshot.docs.map((doc) => ProductModel.fromJson(doc.data())).toList());
  }
}
