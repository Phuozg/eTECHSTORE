import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/product_detail/model/product_detail_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GetProductController {
  @override
  void onInit() {
    getProduct();
  }

  //
  static Future<ProductModel?> getProduct() async {
    ProductModel productModel;
    productModel = (FirebaseFirestore.instance.collection('SanPham')) as ProductModel;
    return productModel;
  }

//
/*   static Future<List<String>?> getListImages(ProductModel productModel) async {
    FirebaseFirestore.instance.collection('SanPham').get().then((querySnapshot) {
      for (var document in querySnapshot.docs) {
        if (document['HinhAnh'] is String) {
          productModel.hinhAnh.add(document['HinhAnh'] as String);
        }
      }
    });
    return null;
  } */
}
