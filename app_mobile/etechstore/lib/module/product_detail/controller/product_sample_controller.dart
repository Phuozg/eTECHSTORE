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
  final discount = <ProductModel>[].obs;

  int price = 0;
  List<String> colors = <String>[].obs;
  List<String> storages = [];
  Map<String, int> priceMap = {};

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var quantity = 1.obs;
  String selectedColor1 = '';
  String selectedStorage = '';

  var selectedColorIndex = 0.obs;
  var selectedConfigIndex = 0.obs;
  var displayedPrice = 0.obs;
  var currentPrice = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProductSamples();
    getSampleProduct();
    getCarts();
    getProduct();
  }

  Stream<List<CartModel>> getCarts() {
    return FirebaseFirestore.instance.collection('GioHang').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => CartModel.fromMap(doc.data())).toList());
  }

  Stream<List<ProductModel>> getProduct() {
    return FirebaseFirestore.instance
        .collection('SanPham')
        .snapshots()
        .map((event) {
      discount.value =
          event.docs.map((e) => ProductModel.fromFirestore(e.data())).toList();
      return discount;
    });
  }

  void setSelectedColorIndex(int index, ProductSampleModel sample) {
    selectedColorIndex.value = index;
    updatePrice(sample);
  }

  void setSelectedConfigIndex(int index, ProductSampleModel sample) {
    selectedConfigIndex.value = index;
    updatePrice(sample);
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
    try {
      if (!isconnected) {
        fetchProductSamplesLocally();
      } else {
        fetchProductSamplesLocally();
        _firestore.collection('MauSanPham').snapshots().listen((event) async {
          productSamples.value = event.docs
              .map((doc) => ProductSampleModel.fromFirestore(doc))
              .toList();
        });

        _localStorageService.saveProductSamples(productSamples);
        fetchProducts();
      }
    } catch (e) {
      Get.snackbar("Thông báo", "Thất bại $e");
    }
  }

  Future<ProductSampleModel?> fetchProductAttributes(String productId) async {
    ProductSampleModel? productSample;

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('MauSanPham')
          .where('MaSanPham', isEqualTo: productId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        productSample = ProductSampleModel.fromFirestore(snapshot.docs.first);
      }
    } catch (e) {
      print('Lỗi khi lấy dữ liệu product sample: $e');
    }

    return productSample;
  }

  void fetchProductSamplesLocally() async {
    List<ProductSampleModel> localProductSamples =
        await _localStorageService.getProductSamples();
    productSamples.assignAll(localProductSamples);

    fetchProductsLocally();
  }

  Stream<List<ProductSampleModel>> getSampleProduct() {
    return _firestore.collection("MauSanPham").snapshots().map((event) {
      var item =
          event.docs.map((e) => ProductSampleModel.fromMap(e.data())).toList();
      productSamples.value = item;
      print(item.length);
      return item;
    });
  }

  String getPrice(ProductSampleModel sample) {
    final colorIndex = selectedColorIndex.value;
    final configIndex = selectedConfigIndex.value;
    final index = colorIndex * sample.cauHinh.length + configIndex;

    if (index < sample.giaTien.length) {
      return sample.giaTien[index].toString();
    } else {
      return 'Không có giá';
    }
  }

  Future<void> fetchProducts() async {
    products.clear();
    for (var sample in productSamples) {
      QuerySnapshot snapshot = await _firestore
          .collection('SanPham')
          .where('id', isEqualTo: sample.MaSanPham)
          .get();
      products.addAll(snapshot.docs
          .map((doc) =>
              ProductModel.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList());
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

  String getSelectedPrice() {
    return currentPrice.value;
  }

  Future<void> updatePrice(ProductSampleModel sample) async {
    final colorIndex = selectedColorIndex.value;
    final configIndex = selectedConfigIndex.value;

    // Tính chỉ số của giá tiền dựa trên chỉ số màu sắc và cấu hình
    final index = colorIndex * sample.cauHinh.length + configIndex;
    print(
        'Color Index: $colorIndex, Config Index: $configIndex, Calculated Index: $index'); // Debugging line

    if (index >= 0 && index < sample.giaTien.length) {
      displayedPrice.value = sample.giaTien[index];
    } else {
      displayedPrice.value =
          0; // Thêm thông báo nếu không có giá cho sự kết hợp này
    }
  }

  Future<void> checkPrice(ProductSampleModel sample, String price) async {
    final index = selectedColorIndex.value * sample.cauHinh.length +
        selectedConfigIndex.value;
    if (index < sample.giaTien.length) {
      currentPrice.value = sample.giaTien[index].toString();
    } else {
      currentPrice.value = price.toString();
    }
  }

  ProductController() {
    getSampleProduct().listen((samples) {
      productSamples.value = samples;
      // Call checkPrice for the first sample (or the relevant sample)
      if (samples.isNotEmpty) {
        checkPrice(samples.first, ''); // Update this as per your logic
      }
    });
  }
}
