import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/home/models/product_model_home.dart';
import 'package:etechstore/module/payment/models/cart_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class OrderItemsController extends GetxController {
  static OrderItemsController get intance => Get.find();
  final db = FirebaseFirestore.instance;
  final userID = FirebaseAuth.instance.currentUser?.uid;
  final allItems = <ProductModel>[].obs;
  final orderItem = <ProductModel>[].obs;
  final allCartsDetail = <CartModel>[].obs;
  RxInt totalPrice = 0.obs;
  RxInt totalDiscount = 0.obs;
  @override
  void onInit() {
    fetchOrderItem();
    super.onInit();
  }

  Future<void> fetchOrderItem() async {
    db.collection('GioHang').where('maKhachHang', isEqualTo: userID).snapshots().listen((snapshot) async {
      var allCartsDetail = snapshot.docs.map((doc) => CartModel.fromSnapshot(doc)).toList();
      final products = await db.collection('SanPham').where('TrangThai', isEqualTo: true).get();
      final items = products.docs.map((document) => ProductModel.fromSnapshot(document)).toList();
      allItems.assignAll(items);
      orderItem.clear();
      for (var cartDetail in allCartsDetail) {
        for (var item in allItems) {
          if (item.id == cartDetail.maSanPham) {
            if (totalPrice <= CartController().instance.totalPrice.value) {
              totalPrice += ((item.GiaTien - (item.GiaTien * item.KhuyenMai / 100)) * cartDetail.soLuong).toInt();
              totalDiscount += ((item.GiaTien * item.KhuyenMai / 100) * cartDetail.soLuong).toInt();
            }
            orderItem.add(item);
          }
        }
      }
    });
  }
}
