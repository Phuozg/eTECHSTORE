/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

abstract class GetProductAbstractController {
  Future<ProductModel?> getProduct();
  Future<void> decreaseQuantity();
  Future<void> increaseQuantity();
}

class GetProductController implements GetProductAbstractController {
  static final fireStore = FirebaseFirestore.instance;
  late final DocumentSnapshot cartModel;

  @override
  void onInit() {
    getProduct();
  }

  //
  @override
  Future<ProductModel?> getProduct() async {
    ProductModel productModel;
    productModel = (fireStore.collection('SanPham')) as ProductModel;
    return productModel;
  }

  //update quantity -
  @override
  Future<void> decreaseQuantity() async {
    print("777777777777777777777777777777777777");
    int currentQuantity = cartModel['SoLuong'];
    await fireStore.collection('SanPhamTrongGioHang').doc("SjO623BnZQKTuMEjcZcg").update({
      'SoLuong': currentQuantity - 1,
    });
  }

  @override
  Future<void> increaseQuantity() async {
    // TODO: implement _increaseQuantity
    print("888888888888888888888888888888888888");
    int currentQuantity = cartModel['SoLuong'];
    await fireStore.collection('SanPhamTrongGioHang').doc("SjO623BnZQKTuMEjcZcg").update({
      'SoLuong': currentQuantity + 1,
    });
    throw UnimplementedError();
  }
}
 */