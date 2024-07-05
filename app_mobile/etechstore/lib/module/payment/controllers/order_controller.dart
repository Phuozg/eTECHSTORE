import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/home/models/product_model_home.dart';
import 'package:etechstore/module/payment/controllers/order_items_controller.dart';
import 'package:etechstore/module/payment/models/model_product_model.dart';
import 'package:etechstore/module/payment/models/order_detail_model.dart';
import 'package:etechstore/module/payment/models/order_model.dart';
import 'package:etechstore/module/payment/views/screen_loader.dart';
import 'package:etechstore/module/payment/views/success_screen.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();
  CartController controller = Get.put(CartController());

  final db = FirebaseFirestore.instance;
  final orderItemController = Get.put(OrderItemsController());
  var id = generateRandomString(20);
  RxList<ModelProductModel> listModel = <ModelProductModel>[].obs;
  Future<void> saveOrder(OrderModel order) async {
    try {
      await db.collection('DonHang').doc(id).set(order.toJson());
    } catch (e) {
      throw 'Something went wrong';
    }
  }

  Future<void> saveOrderDetail(OrderDetail orderDetail) async {
    try {
      await db.collection('CTDonHang').add(orderDetail.toJson());
    } catch (e) {
      throw 'Something went wrong';
    }
  }

  Future<void> clearCart(String userID) async {
    try {
      final querySnapshot = await db
          .collection('GioHang')
          .where('maKhachHang', isEqualTo: userID)
          .where('trangThai', isEqualTo: 1)
          .get();
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    } catch (e) {
      throw 'Something went wrong';
    }
  }

  Future<void> addListModel(
      String color, String config, String productID) async {
    listModel.add(ModelProductModel(
        CauHinh: config, MaSanPham: productID, MauSac: color));
  }

  Future<void> loopAddOrderDetail(var id, String userID) async {
    var index = 0;
    final querySnapshot = await db
        .collection('GioHang')
        .where('maKhachHang', isEqualTo: userID)
        .where('trangThai', isEqualTo: 1)
        .get();
    for (var doc in querySnapshot.docs) {
      var data = doc.data();
      saveOrderDetail(OrderDetail(
          MaDonHang: id,
          SoLuong: data['soLuong'],
          TrangThai: 1,
          KhuyenMai: 0,
          MaMauSanPham: listModel[index].toJson()));
      index++;
    }
  }

  void processOrder(String userID, int totalPrice) async {
    try {
      ScreenLoader.openLoadingDialog();

      if (userID.isEmpty) return;

      id = generateRandomString(20);
      final order = OrderModel(
          id: id,
          TongTien: totalPrice,
          NgayTaoDon: Timestamp.now(),
          MaKhachHang: userID,
          isPaid: true,
          isBeingShipped: false,
          isShipped: false,
          isCompleted: false,
          isCancelled: false);
      await saveOrder(order);

      await loopAddOrderDetail(id, userID);

      await clearCart(userID);
      controller.setTotalPriceAndCheckAll();
      Get.off(() => const SuccessScreen());
    } catch (e) {
      throw 'something went wrong';
    }
  }

  void processOrderBuyNow(
      String userID, int totalPrice, ProductModel product) async {
    try {
      ScreenLoader.openLoadingDialog();

      if (userID.isEmpty) return;

      id = generateRandomString(20);
      final order = OrderModel(
          id: id,
          TongTien: totalPrice,
          NgayTaoDon: Timestamp.now(),
          MaKhachHang: userID,
          isPaid: true,
          isBeingShipped: false,
          isShipped: false,
          isCompleted: false,
          isCancelled: false);
      await saveOrder(order);

      await saveOrderDetail(OrderDetail(
          MaDonHang: id,
          SoLuong: 1,
          TrangThai: 1,
          KhuyenMai: 0,
          MaMauSanPham: ModelProductModel(
                  CauHinh: '1TB', MaSanPham: product.id, MauSac: 'Đen')
              .toJson()));
      controller.setTotalPriceAndCheckAll();
      await clearCart(userID);
      Get.off(() => const SuccessScreen());
    } catch (e) {
      throw 'something went wrong';
    }
  }

  Future<String> getDeviceIP() async {
    final NetworkInfo networkInfo = NetworkInfo();
    final wifiIP = await networkInfo.getWifiIP();
    return wifiIP ?? '';
  }

  Future<void> paymentVNPay(
      int totalAmount, DateTime createDate, String orderID) async {
    final Uri url = Uri.parse(
        'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?vnp_Amount=$totalAmount&vnp_Command=pay&vnp_CreateDate=$createDate&vnp_CurrCode=VND&vnp_IpAddr=${getDeviceIP()}&vnp_Locale=vn&vnp_OrderInfo=Thanh+toan+don+hang+$orderID&vnp_OrderType=other&vnp_ReturnUrl=https%3A%2F%2Fdomainmerchant.vn%2FReturnUrl&vnp_TmnCode=DEMOV210&vnp_TxnRef=5&vnp_Version=2.1.0&vnp_SecureHash=3e0d61a0c0534b2e36680b3f7277743e8784cc4e1d68fa7d276e79c23be7d6318d338b477910a27992f5057bb1582bd44bd82ae8009ffaf6d141219218625c42');
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
