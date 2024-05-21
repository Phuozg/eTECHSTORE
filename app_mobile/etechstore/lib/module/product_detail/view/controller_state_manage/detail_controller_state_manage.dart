import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/product_detail/controller/get_product_controller.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailController extends GetxController {
  static DetailController get instance => Get.find();
  GlobalKey<FormState> DetailProductFormKey = GlobalKey<FormState>();
  late GetProductController getProductController = Get.find<GetProductController>();
  CartController? cartController;
  List<dynamic> slides = <ProductModel>[].obs;
  static final firestore = FirebaseFirestore.instance;

  Future<void> decreaseQuantity() async {
    print("ttttttttttttttttttttttttttttttttttttt");
    await getProductController.decreaseQuantity();
  }

  Future<void> increaseQuantity() async {
    print("ttttttttttttttttttttttttttttttttttttt");
    await getProductController.increaseQuantity();
  }

/*   Future<void> addToCart() async {
    // print(object)

    CartController.addAllProductsToCart(5);
  } */

  var cartItems = List<ProductModel>.empty().obs;

  void addToCart(String currentUserID, final thumbnail, final HinhAnh, final id, final MaDanhMuc, final KhuyenMai, final MoTa, final Ten,
      final SoLuong, final TrangThai, final GiaTien) {
    // Lấy thông tin sản phẩm từ các biến trong class
    ProductModel product = ProductModel(
        thumbnail: thumbnail,
        hinhAnh: HinhAnh,
        maDanhMuc: MaDanhMuc,
        id: id,
        KhuyenMai: KhuyenMai,
        moTa: MoTa,
        soLuong: SoLuong,
        ten: Ten,
        trangThai: TrangThai,
        giaTien: GiaTien);

    // Gọi phương thức thêm sản phẩm vào giỏ hàng từ CartController
    //  CartController.addToCart(product, 7);
  }

  void clearCart() {
    cartItems.clear();
  }
}
