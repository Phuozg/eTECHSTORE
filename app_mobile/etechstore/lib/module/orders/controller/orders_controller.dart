import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/home/models/product_model_home.dart';
import 'package:etechstore/module/orders/model/detail_orders.dart';
import 'package:etechstore/module/orders/model/orders_model.dart';
import 'package:etechstore/utlis/helpers/popups/loader.dart';
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
  var lstOrder = <DetailOrders>[].obs;

  var itemsToShow = 1.obs;

  OrdersModel order = OrdersModel(
    id: "",
    ngayTaoDon: Timestamp.now(),
    maKhachHang: "",
    tongTien: 0,
    isPaid: false,
    isBeingShipped: false,
    isShipped: false,
    isCompleted: false,
  );

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
    fetchData();
    getOrder();
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

  Future<List<DetailOrders>> checkItemInOrder(String maDonHang) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('CTDonHang').get();
      lstOrder.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        var maMauSanPham = data['MaDonHang'];
        if (maMauSanPham == maDonHang) {
          lstOrder.add(DetailOrders.fromJson(data));
        }
      }
    } catch (e) {
      TLoaders.warningSnackBar(title: "Thông báo", message: "Đã có lỗi xảy ra $e");
    }
    return lstOrder;
  }

  Stream<List<OrdersModel>> getOrder() {
    return _firestore.collection('DonHang').snapshots().map((snapshot) => snapshot.docs.map((doc) {
          return OrdersModel.fromJson(doc.data());
        }).toList());
  }

  Future<void> getOrderA() async {
    FirebaseFirestore.instance.collection('CTDonHang').snapshots().listen((snapshot) {
      lstOrder.clear();
      for (var model in snapshot.docs) {
        lstOrder.add(DetailOrders.fromJson(model.data()));
      }
    });
  }

  Stream<List<DetailOrders>> getCTDonHangs(String maDonHang) {
    return _firestore
        .collection('CTDonHang')
        .where('MaDonHang', isEqualTo: maDonHang)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => DetailOrders.fromJson(doc.data())).toList());
  }

   getQuantityProduct(String orderID  ) {
    var quantity = [];
    for (var order in lstOrder) {
      if (order.maDonHang  == orderID) {
        quantity.add(order.maDonHang.trim());
      }
    }
    return quantity;
  }

  int getQuantity(List<DetailOrders> ctDonHangs, String orderID) {
  return ctDonHangs.where((order) => order.maDonHang == orderID).length;
}


  Future<Map<String, int>> countDonHangInCTDonHang(String maDonHang) async {
    QuerySnapshot snapshot = await _firestore.collection('CTDonhang').get();
    Map<String, int> countMap = {};

    for (var doc in snapshot.docs) {
        maDonHang = doc.get('MaDonHang');
      if (countMap.containsKey(maDonHang)) {
        countMap[maDonHang] = countMap[maDonHang]! + 1;
      } else {
        countMap[maDonHang] = 1;
      }
    }

    return countMap;
  }

  Stream<List<ProductModel>> getProduct() {
    return _firestore.collection('SanPham').snapshots().map((snapshot) => snapshot.docs.map((doc) => ProductModel.fromJson(doc.data())).toList());
  }

  Future<void> deleteOrder(String orderID) async {
    final snapshot = await FirebaseFirestore.instance.collection('CTDonHang').where('MaDonHang', isEqualTo: orderID).get();
    for (var doc in snapshot.docs) {
      final data = doc.data();
      updateQuantity(data['SoLuong'], data['MaMauSanPham']['MaSanPham']);
      doc.reference.update({'TrangThai': 1});
    }
    FirebaseFirestore.instance.collection('DonHang').doc(orderID).update({
      'isBeingShipped': true,
      'isCompleted': false,
      'isPaid': false,
    });
  }

  Future<void> updateQuantity(int quantity, String productID) async {
    try {
      int quantityModel = 0;
      await FirebaseFirestore.instance.collection('MauSanPham').where('MaSanPham', isEqualTo: productID).get().then((value) {
        for (var element in value.docs) {
          quantityModel = element.data()['SoLuong'];
          element.reference.update({'SoLuong': quantityModel + quantity});
        }
      });
    } catch (e) {
      throw 'Something wrong';
    }
  }
}
