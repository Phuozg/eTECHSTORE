import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/home/models/product_model_home.dart';
import 'package:etechstore/module/orders/model/detail_orders.dart';
import 'package:etechstore/module/orders/model/orders_model.dart';
  import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersController extends GetxController {
  OrdersController get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var ordersItem = <String, OrdersModel>{}.obs;
  var products = <String, ProductModel>{}.obs;

  var detailOrder = <DetailOrders>[].obs;

  var itemsToShow = 1.obs;

  void loadMore() {
    itemsToShow.value += 10;
  }

  void disLoadMore() {
    itemsToShow.value = 2;
  }

  @override
  void onInit() {
    super.onInit();
    loadMore();
    fetchIsPaid();
    fetchData();
  }

  Stream<List<OrdersModel>> fetchIsPaid() {
    String? userId = _auth.currentUser?.uid;

    return FirebaseFirestore.instance.collection('DonHang').where('MaKhachHang', isEqualTo: userId).snapshots().map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) {
            return OrdersModel.fromJson(doc.data());
          })
          .where((order) => order.isPaid || order.isBeingShipped || order.isShipped || order.isCompleted  )
          .toList();
    });
  }

  Stream<List<DetailOrders>> fetchData() {
    return _firestore.collection('CTDonHang').where('TrangThai', isEqualTo: 1).snapshots().asyncMap((snapshot) async {
      final items = await Future.wait(
        snapshot.docs.map((doc) async {
          final detailItem = DetailOrders.fromJson(doc.data());

          final productDoc = await _firestore.collection('SanPham').doc(detailItem.maMauSanPham['MaSanPham']).get();
          if (productDoc.exists) {
            products[detailItem.maMauSanPham['MaSanPham']] = ProductModel.fromJson(productDoc.data() as Map<String, dynamic>);
          }

          final orderDoc = await _firestore.collection('DonHang').doc(detailItem.maDonHang).get();
          if (orderDoc.exists) {
            ordersItem[detailItem.maDonHang] = OrdersModel.fromJson(orderDoc.data() as Map<String, dynamic>);
          }

          return detailItem;
        }),
      );
      return items;
    });
  }

  Stream<List<OrdersModel>> getOrder() {
    return _firestore.collection('DonHang').snapshots().map((snapshot) => snapshot.docs.map((doc) => OrdersModel.fromJson(doc.data())).toList());
  }

  Stream<List<DetailOrders>> getCTDonHangs(String maDonHang) {
    return _firestore
        .collection('CTDonHang')
        .where('MaDonHang', isEqualTo: maDonHang)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => DetailOrders.fromJson(doc.data())).toList());
  }

  Stream<List<ProductModel>> getProduct() {
    return _firestore.collection('SanPham').snapshots().map((snapshot) => snapshot.docs.map((doc) => ProductModel.fromJson(doc.data())).toList());
  }

  Future<void> deleteOrder(String orderID) async {
    final snapshot = await FirebaseFirestore.instance.collection('CTDonHang').where('MaDonHang', isEqualTo: orderID).get();
    for (var doc in snapshot.docs) {
      doc.reference.update({'TrangThai': 1});
    }
    FirebaseFirestore.instance.collection('DonHang').doc(orderID).update({
      'isBeingShipped': true,
      'isPaid': false,
    });
  }
}
