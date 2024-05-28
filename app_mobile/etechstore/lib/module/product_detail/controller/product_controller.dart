import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:etechstore/module/product_detail/model/product_sample_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final firestore = FirebaseFirestore.instance;
  ProductController get instance => Get.find();
  final CartController cartController = Get.put(CartController());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var productSamples = <ProductSampleModel>[].obs;
  var products = <ProductModel>[].obs;
   var currentIndex = 1.obs;


  @override
  void onInit() {
    super.onInit();
    fetchProductSamples();
  }


  void setCurrentIndex(int index) {
    currentIndex.value = index;
  }

  void resetIndex() {
    currentIndex.value = 0;
  }

  void fetchProductSamples() async {
    QuerySnapshot snapshot = await _firestore.collection('MauSanPham').get();
    productSamples.value = snapshot.docs.map((doc) => ProductSampleModel.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    fetchProducts();
  }

  void fetchProducts() async {
    for (var sample in productSamples) {
      QuerySnapshot snapshot = await _firestore.collection('SanPham').where('id', isEqualTo: sample.MaSanPham).get();
      products.addAll(snapshot.docs.map((doc) => ProductModel.fromFirestore(doc.data() as Map<String, dynamic>)).toList());
    }
  }

  void addProductToCart(ProductSampleModel sample, String selectedColor, String selectedConfig, int quantity) {
    var cartItem = CartModel(
      id: sample.id,
      maKhachHang: "5sNAoX3ON2PJXWOkY3d4k60DHeu2", // Thay bằng mã khách hàng thực tế
      soLuong: quantity,
      trangThai: 0, // Trạng thái mặc định, có thể thay đổi tuỳ vào logic của bạn
      maSanPham: {
        'maSanPham': sample.MaSanPham,
        'mauSac': selectedColor,
        'cauHinh': selectedConfig,
      },
    );
    cartController.addItemToCart(cartItem);
  }
}
