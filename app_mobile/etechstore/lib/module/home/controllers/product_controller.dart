import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/home/models/product_model.dart';
import 'package:get/get.dart';

class ProductControllerr extends GetxController{
  static ProductControllerr get instance => Get.find();

  final db = FirebaseFirestore.instance;
  var allProduct = <ProductModel>[].obs;
  var discountProducts = <ProductModel>[].obs;
  var popularProducts = <ProductModel>[].obs;
  @override
  void onInit(){
    fetchProduct();
    super.onInit();
  }

  Future<void> fetchProduct() async {
    //fetch all product
    final snapshot = await db.collection('SanPham').where('TrangThai',isEqualTo: true).get();
    final products = snapshot.docs.map((document) => ProductModel.fromSnapshot(document)).toList();
    allProduct.assignAll(products);

    //fetch discount product
    discountProducts.assignAll(allProduct.where((product) => product.KhuyenMai>0).take(6).toList());

    //fetch popular product
    popularProducts.assignAll(allProduct.where((product) => product.isPopular).take(6).toList());
  }
}