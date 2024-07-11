import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/home/models/product_model_home.dart';
import 'package:get/get.dart';

class ProductControllerr extends GetxController {
  static ProductControllerr get instance => Get.find();

  final db = FirebaseFirestore.instance;
  final RxString selectedSortOption = 'Tên'.obs;
  RxList<ProductModel> products = <ProductModel>[].obs;
  var allProduct = <ProductModel>[].obs;
  var discountProducts = <ProductModel>[].obs;
  var popularProducts = <ProductModel>[].obs;
  var filterProduct = <ProductModel>[].obs;
  RxBool isFilter = false.obs;
  @override
  void onInit() {
    fetchProduct();
    super.onInit();
  }

  Future<void> fetchProduct() async {
    //fetch all product
    final snapshot = await db
        .collection('SanPham')
        .where('TrangThai', isEqualTo: true)
        .get();
    final products = snapshot.docs
        .map((document) => ProductModel.fromSnapshot(document))
        .toList();
    allProduct.assignAll(products);

    //fetch discount product
    discountProducts.assignAll(
        allProduct.where((product) => product.KhuyenMai > 0).take(6).toList());

    //fetch popular product
    popularProducts.assignAll(
        allProduct.where((product) => product.isPopular).take(6).toList());
  }

  RxList<ProductModel> queryProduct(String query) {
    if (query == 'allProduct') {
      return allProduct;
    }
    if (query == 'discountProduct') {
      return discountProducts;
    }
    if (query == 'popularProduct') {
      return popularProducts;
    }
    return allProduct;
  }

  //
  Future<List<ProductModel>> fetchProductsByQuery(Query? query) async {
    try {
      final querySnapshot = await query!.get();
      final List<ProductModel> productList = querySnapshot.docs
          .map((doc) => ProductModel.fromQuerySnapshot(doc))
          .toList();
      return productList;
    } catch (e) {
      throw 'Something went wrong';
    }
  }

  //
  void sortProducts(String sortOption) {
    selectedSortOption.value = sortOption;
    switch (sortOption) {
      case 'Tên':
        products.sort((a, b) => a.Ten.compareTo(b.Ten));
        break;
      case 'Giá cao':
        products.sort((a, b) => b.GiaTien.compareTo(a.GiaTien));
        break;
      case 'Giá thấp':
        products.sort((a, b) => a.GiaTien.compareTo(b.GiaTien));
        break;
      case 'Mới nhất':
        products.sort((a, b) => a.NgayNhap.compareTo(b.NgayNhap));
        break;
      case 'Khuyến mãi':
        products.sort((a, b) {
          if (b.KhuyenMai > 0) {
            return b.KhuyenMai.compareTo(a.KhuyenMai);
          } else if (a.KhuyenMai > 0) {
            return -1;
          } else {
            return 1;
          }
        });
        break;
      default:
        products.sort((a, b) => a.Ten.compareTo(b.Ten));
    }
  }

  //
  void assignProducts(List<ProductModel> products) {
    this.products.assignAll(products);
    sortProducts('Tên');
  }

  Future<List<ProductModel>> getProductsForCate(
      {required int catId, int limit = -1}) async {
    try {
      final querySnapshot = catId == 0
          ? await db
              .collection('SanPham')
              .where('TrangThai', isEqualTo: true)
              .get()
          : limit == -1
              ? await db
                  .collection('SanPham')
                  .where('MaDanhMuc', isEqualTo: catId)
                  .where('TrangThai', isEqualTo: true)
                  .get()
              : await db
                  .collection('SanPham')
                  .where('MaDanhMuc', isEqualTo: catId)
                  .where('TrangThai', isEqualTo: true)
                  .limit(limit)
                  .get();

      final products = querySnapshot.docs
          .map((doc) => ProductModel.fromSnapshot(doc))
          .toList();
      return products;
    } catch (e) {
      throw 'Something went wrong';
    }
  }

  void filter(double minPrice, double maxPrice) {
    allProduct.clear();
    allProduct.assignAll(products);
    allProduct.removeWhere(
        (product) => product.GiaTien < minPrice || product.GiaTien > maxPrice);
  }
}
