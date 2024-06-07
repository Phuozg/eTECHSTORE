import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/payment/controllers/order_items_controller.dart';
import 'package:etechstore/module/payment/models/model_product_model.dart';
import 'package:etechstore/module/payment/models/order_detail_model.dart';
import 'package:etechstore/module/payment/models/order_model.dart';
import 'package:etechstore/module/payment/views/screen_loader.dart';
import 'package:etechstore/module/payment/views/success_screen.dart';
import 'package:get/get.dart';

class OrderController extends GetxController{
  static OrderController get instance => Get.find();

  final db = FirebaseFirestore.instance;
  final orderItemController = Get.put(OrderItemsController());
  final id = generateRandomString(20);
  Future<void> saveOrder(OrderModel order) async {
    try{
      await db.collection('DonHang').add(order.toJson());
    } catch (e){
      throw 'Something went wrong';
    }
  }

  Future<void> saveOrderDetail(OrderDetail orderDetail) async {
    try{
      await db.collection('CTDonHang').doc(id).set(orderDetail.toJson());
    } catch (e){
      throw 'Something went wrong';
    }
  }

  Future<void> clearCart(String userID) async{
    try{
      final querySnapshot = await db.collection('GioHang').where('maKhachHang',isEqualTo: userID).get();
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
       });
    } catch (e){
      throw 'Something went wrong';
    }
  }

  void processOrder(String userID,int totalPrice,int totalDiscount) async {
    try{
      ScreenLoader.openLoadingDialog();

      if(userID.isEmpty) return;

      final order = OrderModel(
        id: id,
        TongTien: totalPrice, 
        TongDuocGiam: totalDiscount, 
        NgayTaoDon: Timestamp.now(), 
        MaKhachHang: userID, 
        isPaid: true, 
        isBeingShipped: false, 
        isShipped: false, 
        isCompleted: false, 
        isCancelled: false
      );
      await saveOrder(order);

      for(var cartDetail in orderItemController.allCartsDetail){
        for(var item in orderItemController.allItems){
          if(item.id == cartDetail.maSanPham){
            await saveOrderDetail(
              OrderDetail(
                MaDonHang:  id, 
                SoLuong: cartDetail.soLuong, 
                TrangThai: 1, 
                KhuyenMai: item.KhuyenMai, 
                MauSanPham: ModelProductModel(CauHinh: '',MaSanPham: item.id,MauSac: '').toJson())
            );
          }
        }
      }

      clearCart(userID);
      Get.off(()=> const SuccessScreen());
    } catch (e){
      throw 'something went wrong';
    }
  }
}
String generateRandomString(int length) {
  final random = Random();
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  ));
}