import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/orders/model/detail_orders.dart';
import 'package:etechstore/module/product_detail/model/product_sample_model.dart';
import 'package:etechstore/module/profile/model/local_storage_service.dart';
import 'package:etechstore/utlis/connection/network_manager.dart';
import 'package:etechstore/utlis/helpers/popups/loader.dart';
import 'package:get/get.dart';

import '../model/product_model.dart';

class ProductSampleController extends GetxController {
  ProductSampleController get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalStorageService _localStorageService = LocalStorageService();
  final NetworkManager network = Get.put(NetworkManager());

  var productSamples = <ProductSampleModel>[].obs;
  var products = <ProductModel>[].obs;
  final lstProduct = <DetailOrders>[].obs;
  final discount = <ProductModel>[].obs;

  String selectedColor1 = '';
  String selectedStorage = '';
  var selectedColorIndex = 0.obs;
  var selectedConfigIndex = 0.obs;
  var currentPrice = ''.obs;
  var currentIndex = 1.obs;

  RxList<ProductSampleModel> listModel = <ProductSampleModel>[].obs;

  @override
  void onInit() {
    fetchModelProduct();
    super.onInit();
    getSampleProduct();
    getCarts();
    getProduct();
  }

  Stream<List<CartModel>> getCarts() {
    return FirebaseFirestore.instance
        .collection('GioHang')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => CartModel.fromMap(doc.data())).toList());
  }

  Stream<List<ProductModel>> getProduct() {
    return FirebaseFirestore.instance.collection('SanPham').snapshots().map((event) {
      discount.value = event.docs.map((e) => ProductModel.fromFirestore(e.data())).toList();
      return discount;
    });
  }

  void setSelectedColorIndex(int index, ProductSampleModel sample) {
    selectedColorIndex.value = index;
  }

  void setSelectedConfigIndex(int index, ProductSampleModel sample) {
    selectedConfigIndex.value = index;
  }

  void setCurrentIndex(int index) {
    currentIndex.value = index;
  }

  void resetIndex() {
    currentIndex.value = 0;
  }

  void fetchProductSamplesLocally() async {
    List<ProductSampleModel> localProductSamples = await _localStorageService.getProductSamples();
    productSamples.assignAll(localProductSamples);
    fetchProductsLocally();
  }

  Stream<List<ProductSampleModel>> getSampleProduct() {
    return _firestore.collection("MauSanPham").snapshots().map((event) {
      var item = event.docs.map((e) => ProductSampleModel.fromMap(e.data())).toList();
      productSamples.value = item;
      return item;
    });
  }

  Future<void> fetchProducts() async {
    products.clear();
    for (var sample in productSamples) {
      QuerySnapshot snapshot = await _firestore.collection('SanPham').where('id', isEqualTo: sample.MaSanPham).get();
      products.addAll(snapshot.docs.map((doc) => ProductModel.fromFirestore(doc.data() as Map<String, dynamic>)).toList());
    }

    _localStorageService.saveProducts(products);
  }

  Future<void> productsSold(String id) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('CTDonHang').get();

      lstProduct.clear();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, dynamic> maMauSanPham = data['MaMauSanPham'] as Map<String, dynamic>;
        if (maMauSanPham['MaSanPham'] == id) {
          lstProduct.add(DetailOrders.fromJson(data));
        }
      }
    } catch (e) {
      TLoaders.warningSnackBar(title: "Thông báo", message: "Đã có lỗi xảy ra");
    }
  }

  void fetchProductsLocally() async {
    List<ProductModel> localProducts = await _localStorageService.getProducts();
    products.assignAll(localProducts);
  }

  String getSelectedPrice() {
    return currentPrice.value;
  }

  Future<void> checkPrice(ProductSampleModel sample, String price) async {
    final index = selectedColorIndex.value * sample.cauHinh.length + selectedConfigIndex.value;
    if (index < sample.giaTien.length) {
      currentPrice.value = (sample.giaTien[index]).toString();
    } else {
      currentPrice.value = price.toString();
    }
  }

  Future<void> fetchModelProduct() async {
    FirebaseFirestore.instance.collection('MauSanPham').get().then((snapshot) {
      listModel.clear();
      for (var model in snapshot.docs) {
        listModel.add(ProductSampleModel.fromFirestore(model));
      }
    });
  }
  

  check(String userID)async {
    await fetchModelProduct();
    var querySnapshot = await FirebaseFirestore.instance
      .collection('GioHang')
      .where('maKhachHang', isEqualTo: userID)
      .where('trangThai', isEqualTo: 1)
      .get();

  for (var doc in querySnapshot.docs) {
    var data = doc.data();
    var model = listModel.firstWhere((element) => element.MaSanPham == data['mauSanPham']['maSanPham']);
    if (model.soLuong < data['soLuong']) {
      return false;
    }
  }
    return true;
  }
}
