import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/orders/model/detail_orders.dart';
import 'package:etechstore/module/orders/model/orders_model.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
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

  @override
  void onInit() {
    super.onInit();
    super.onInit();
    fetchIsPaid();
    fetchData();
  }

  Stream<List<OrdersModel>> fetchIsPaid() {
    print("hello 2");
    String? userId = _auth.currentUser?.uid;

    return FirebaseFirestore.instance.collection('DonHang').where('MaKhachHang', isEqualTo: userId).snapshots().map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) {
            return OrdersModel.fromJson(doc.data());
          })
          .where((order) => order.isPaid || order.isBeingShipped || order.isShipped || order.isCompleted || order.isCancelled)
          .toList();
    });
  }

  Stream<List<DetailOrders>> fetchData() {
    print("hello 1");
    String? userId = _auth.currentUser?.uid;

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
    print("hello 3");
    return _firestore.collection('DonHang').snapshots().map((snapshot) => snapshot.docs.map((doc) => OrdersModel.fromJson(doc.data())).toList());
  }

  Stream<List<DetailOrders>> getCTDonHangs() {
    print("hello 4");
    return _firestore.collection('CTDonHang').snapshots().map((snapshot) => snapshot.docs.map((doc) => DetailOrders.fromJson(doc.data())).toList());
  }

  Stream<List<ProductModel>> getProduct() {
    print("hello 5");
    return _firestore.collection('SanPham').snapshots().map((snapshot) => snapshot.docs.map((doc) => ProductModel.fromJson(doc.data())).toList());
  }

  void fetchOrdersAndCartItems() async {
    print("hello 6");
    String? userId = _auth.currentUser?.uid;
    if (userId != null) {
      FirebaseFirestore.instance.collection('DonHang').where('MaKhachHang', isEqualTo: userId).snapshots().listen((ordersSnapshot) async {
        ordersItem.clear();
        for (var doc in ordersSnapshot.docs) {
          var order = OrdersModel.fromJson(doc.data());
          ordersItem[doc.id] = order;
        }

        await for (var snapshot in _firestore.collection('CTDonHang').where('TrangThai', isEqualTo: 1).snapshots()) {
          var items = snapshot.docs.map((doc) => DetailOrders.fromJson(doc.data())).toList();
          var validItems = <DetailOrders>[];

          for (var item in items) {
            if (ordersItem[item.maDonHang] != null) {
              var order = ordersItem[item.maDonHang]!;
              if (order.isPaid || order.isBeingShipped || order.isShipped || order.isCompleted || order.isCancelled) {
                validItems.add(item);
              }
            }
          }

          for (var item in validItems) {
            var productDoc = await _firestore.collection('SanPham').doc(item.maMauSanPham['MaSanPham']).get();
            if (productDoc.exists) {
              products[item.maMauSanPham['MaSanPham']] = ProductModel.fromFirestore(productDoc.data() as Map<String, dynamic>);
            }
          }

          detailOrder.assignAll(validItems);
        }
      });
    }
  }
}
