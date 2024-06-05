/* import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/product_model.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var products = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    QuerySnapshot snapshot = await _firestore.collection('SanPham').get();
    products.value = snapshot.docs.map((doc) => ProductModel.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
  }
}
 */