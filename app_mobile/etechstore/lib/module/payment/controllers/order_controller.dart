import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  var id = generateRandomString(20);
  Future<void> saveOrder(OrderModel order) async {
    try{
      await db.collection('DonHang').doc(id).set(order.toJson());
    } catch (e){
      throw 'Something went wrong';
    }
  }

  Future<void> saveOrderDetail(OrderDetail orderDetail) async {
    try{
      await db.collection('CTDonHang').add(orderDetail.toJson());
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

  Future<void> loopAddOrderDetail(var id,String userID) async{
    // db.collection('GioHang').where('maKhachHang',isEqualTo: userID).snapshots().listen((event) {
    //   event.docs.forEach((snapshot) {
    //     var data = snapshot.data();
    //     saveOrderDetail(
    //     OrderDetail(
    //       MaDonHang:  id, 
    //       SoLuong: data['soLuong'], 
    //       TrangThai: 1, 
    //       KhuyenMai: 0, 
    //       MauSanPham: ModelProductModel(CauHinh: '1TB',MaSanPham: data['mauSanPham']['maSanPham'],MauSac: 'Đen').toJson())
    //   );
    //   });
    // });
    db.collection('GioHang').where('maKhachHang',isEqualTo: userID).get().then((value) {
      value.docs.forEach((snapshot) {
        var data = snapshot.data();
        saveOrderDetail(
        OrderDetail(
          MaDonHang:  id, 
          SoLuong: data['soLuong'], 
          TrangThai: 1, 
          KhuyenMai: 0, 
          MauSanPham: ModelProductModel(CauHinh: '1TB',MaSanPham: data['mauSanPham']['maSanPham'],MauSac: 'Đen').toJson())
      );
      });
    });
  }

  void processOrder(String userID,int totalPrice,int totalDiscount) async {
    try{
      ScreenLoader.openLoadingDialog();

      if(userID.isEmpty) return;
      
      id = generateRandomString(20);
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

      await loopAddOrderDetail(id,userID);
      
      await clearCart(userID);
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