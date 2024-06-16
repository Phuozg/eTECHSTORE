import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/product_detail/model/product_sample_model.dart';
import 'package:etechstore/module/profile/model/local_storage_service.dart';
import 'package:etechstore/utlis/connection/network_manager.dart';
import 'package:get/get.dart';

import '../model/product_model.dart';

class ProductSampleController extends GetxController {
  ProductSampleController get instance => Get.find();
  var productSamples = <ProductSampleModel>[].obs;
  var products = <ProductModel>[].obs;
  final LocalStorageService _localStorageService = LocalStorageService();
  final NetworkManager network = Get.put(NetworkManager());

  var selectedColor = ''.obs;
  var selectedConfig = ''.obs;
  var quantity = 1.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchProductSamples();
  }

  var currentIndex = 1.obs;

  void setCurrentIndex(int index) {
    currentIndex.value = index;
  }

  void resetIndex() {
    currentIndex.value = 0;
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
     final isconnected = network.isConnectedToInternet.value;
    if (!isconnected) {
      fetchProductSamplesLocally();
    } else {
      fetchProductSamplesLocally();
      QuerySnapshot snapshot = await _firestore.collection('MauSanPham').get();
      productSamples.value = snapshot.docs.map((doc) => ProductSampleModel.fromFirestore(doc.data() as Map<String, dynamic>)).toList();

      _localStorageService.saveProductSamples(productSamples);
      fetchProducts();
    }
  }

  void fetchProductSamplesLocally() async {
    List<ProductSampleModel> localProductSamples = await _localStorageService.getProductSamples();
    productSamples.assignAll(localProductSamples);

    fetchProductsLocally();
  }

  void fetchProducts() async {
    products.clear();
    for (var sample in productSamples) {
      QuerySnapshot snapshot = await _firestore.collection('SanPham').where('id', isEqualTo: sample.MaSanPham).get();
      products.addAll(snapshot.docs.map((doc) => ProductModel.fromFirestore(doc.data() as Map<String, dynamic>)).toList());
    }

    _localStorageService.saveProducts(products);
  }

  void fetchProductsLocally() async {
    List<ProductModel> localProducts = await _localStorageService.getProducts();
    products.assignAll(localProducts);
  }
}
