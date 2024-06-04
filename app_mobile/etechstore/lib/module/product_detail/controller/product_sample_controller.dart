import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/product_detail/model/product_sample_model.dart';
import 'package:get/get.dart';

import '../model/product_model.dart';

class ProductSampleController extends GetxController {
  ProductSampleController get instance => Get.find();
  var productSamples = <ProductSampleModel>[].obs;
  var products = <ProductModel>[].obs;

   var selectedColor = ''.obs;
  var selectedConfig = ''.obs;
  var quantity = 1.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchProductSamples();
  }

 

  void setSelectedColor(String color) {
    selectedColor.value = color;
  }

  void setSelectedConfig(String config) {
    selectedConfig.value = config;
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
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
}
