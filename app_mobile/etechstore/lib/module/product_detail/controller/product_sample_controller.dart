import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/orders/model/detail_orders.dart';
import 'package:etechstore/module/product_detail/model/product_sample_model.dart';
import 'package:etechstore/module/profile/model/local_storage_service.dart';
import 'package:etechstore/utlis/connection/network_manager.dart';
import 'package:etechstore/utlis/helpers/popups/loader.dart';
import 'package:get/get.dart';

import '../model/product_model.dart';

class ProductSampleController extends GetxController {
  ProductSampleController get instance => Get.find();
  var productSamples = <ProductSampleModel>[].obs;
  var products = <ProductModel>[].obs;
  final LocalStorageService _localStorageService = LocalStorageService();
  final NetworkManager network = Get.put(NetworkManager());

  final lstProduct = <DetailOrders>[].obs;
  final RxBool _isProductsLoaded = false.obs;

  int price = 0;
  List<String> colors = <String>[].obs;
  List<String> storages = [];
  Map<String, int> priceMap = {};

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var quantity = 1.obs;
  String selectedColor1 = '';
  String selectedStorage = '';

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
    quantity.value = 1;
  }

  Future<void> fetchProductSamples() async {
    final isconnected = network.isConnectedToInternet.value;
    if (!isconnected) {
      fetchProductSamplesLocally();
    } else {
      fetchProductSamplesLocally();
      _firestore.collection('MauSanPham').snapshots().listen((event) async {
        productSamples.value = event.docs.map((doc) => ProductSampleModel.fromFirestore(doc)).toList();
      });

      _localStorageService.saveProductSamples(productSamples);
      fetchProducts();
    }
  }

  void updatePrice() {
    if (selectedColor1.isNotEmpty && selectedStorage.isNotEmpty) {
      String key = '$selectedColor1-$selectedStorage';

      price = priceMap[key] ?? 0;
    } else if (selectedColor1.isNotEmpty && selectedStorage.isEmpty) {
      String key = '$selectedColor1-';

      price = priceMap[key] ?? 0;

      print("== $priceMap");
    } else if (selectedStorage.isNotEmpty && selectedColor1.isEmpty) {
      String key = '$selectedStorage-';

      price = priceMap[key] ?? 0;
    } else {
      return;
    }
  }

  Future<ProductSampleModel?> fetchProductAttributes(String productId) async {
    ProductSampleModel? productSample;

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('MauSanPham').where('MaSanPham', isEqualTo: productId).limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        productSample = ProductSampleModel.fromFirestore(snapshot.docs.first);
      }
    } catch (e) {
      print('Lỗi khi lấy dữ liệu product sample: $e');
    }

    return productSample;
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

  Future<void> productsSold(String id) async {
    if (_isProductsLoaded.value) return;

    try {
      QuerySnapshot snapshot = await _firestore.collection('CTDonHang').get();
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String productId = data['MaMauSanPham']['MaSanPham'];

        if (productId == id) {
          lstProduct.add(DetailOrders.fromJson(data));
        }
      }
      _isProductsLoaded.value = true;
    } catch (e) {
      TLoaders.warningSnackBar(title: "Thông báo", message: "Đã có lỗi xảy ra");
    }
  }

  void fetchProductsLocally() async {
    List<ProductModel> localProducts = await _localStorageService.getProducts();
    products.assignAll(localProducts);
  }
}
