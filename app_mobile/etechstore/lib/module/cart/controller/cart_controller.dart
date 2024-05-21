import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class CartController extends GetxController {

  static CartController get instance => Get.find();
  GlobalKey<FormState> DetailProductFormKey = GlobalKey<FormState>();
  static final firestore = FirebaseFirestore.instance;
    static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final String currentUserID = firebaseAuth.currentUser!.uid;
  final Rxn<int> selected = Rxn<int>();

  static Future<void> addToCart(DocumentSnapshot productDoc, int soLuong) async {
    // Tạo UUID cho maGioHang
    var uuid = const Uuid();
    String GioHangId = uuid.v4();
    //Tạo UUID cho idGioHang
    var id = const Uuid();
    String idGioHang = id.v4();

    // Lấy ID của sản phẩm hiện tại từ DocumentSnapshot
    final maSanPham = productDoc.id;

    CartModel cartModel = CartModel(
      maKhachHang: currentUserID,
      maGioHang: GioHangId,
      maSanPham: maSanPham,
      soLuong: soLuong,
      id: idGioHang, // ID có thể được tạo ngẫu nhiên hoặc theo logic riêng
    );

    // Thêm sản phẩm vào giỏ hàng
    await firestore.collection('SanPhamTrongGioHang').doc(GioHangId).collection('GioHang').add(cartModel.toJson());
  }

  static Future<void> addAllProductsToCart(int soLuong) async {
    // Lấy tất cả các tài liệu trong bộ sưu tập 'SanPham'
    final querySnapshot = await firestore.collection('SanPham').get();

    // Duyệt qua tất cả các tài liệu và gọi addToCart cho mỗi tài liệu
    for (var doc in querySnapshot.docs) {
      await addToCart(doc, soLuong);
    }
  }

/*   static Stream<List<Map<String, dynamic>>> getCartProduct() {
    return firestore.collection('SanPhamTrongGioHang').where('GioHang', isEqualTo: currentUserID).snapshots().map((snapshot) {
      return snapshot.docs.map((e) {
        final maGioHang = e.data();
        return maGioHang;
      }).toList();
    });
  } */
/*   static List<Map<String, dynamic>> products = [];
  static Stream<List<Map<String, dynamic>>> getCartProduct(String currentUserID) async* {
    var cartStream = firestore.collection('SanPhamTrongGioHang').doc(currentUserID).collection('GioHang').snapshots();

    await for (var snapshot in cartStream) {
      for (var doc in snapshot.docs) {
        String maSanPham = doc['MaSanPham'];

        var productDoc = await firestore.collection('SanPham').doc(maSanPham).get();

        if (productDoc.exists) {
          products.add(productDoc.data() as Map<String, dynamic>);
        }
      }

      yield products;
    }
  }
 */

  static List<Map<String, dynamic>> products = [];

  static void addProductToCart(Map<String, dynamic> product) {
    products.add(product);
  }

  static Stream<List<Map<String, dynamic>>> getCartProduct(String currentUserID) async* {
    var cartStream = firestore.collection('SanPhamTrongGioHang').doc(currentUserID).collection('GioHang').snapshots();

    await for (var snapshot in cartStream) {
      products.clear(); // Clear the current products list
      for (var doc in snapshot.docs) {
        String maSanPham = doc['MaSanPham'];
        var productDoc = await firestore.collection('SanPham').doc(maSanPham).get();

        if (productDoc.exists) {
          products.add(productDoc.data() as Map<String, dynamic>);
        }
      }
      yield products;
    }
  }

  Future<void> incrementQuantity(String currentUserID, final productID) async {
    var cartRef = firestore.collection('SanPhamTrongGioHang').doc(currentUserID).collection('GioHang').doc(productID);

    firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(cartRef);

      if (snapshot.exists) {
        int currentQuantity = snapshot.get('SoLuong');
        transaction.update(cartRef, {'SoLuong': currentQuantity + 1});
      } else {
        transaction.set(cartRef, {'SoLuong': 1});
      }
    });
  }

  Future<void> decrementQuantity(String currentUserID, final productID) async {
    var cartRef = firestore.collection('SanPhamTrongGioHang').doc(currentUserID).collection('GioHang').doc(productID);

    firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(cartRef);

      if (snapshot.exists) {
        int currentQuantity = snapshot.get('SoLuong');
        if (currentQuantity > 1) {
          transaction.update(cartRef, {'SoLuong': currentQuantity - 1});
        } else {
          transaction.delete(cartRef);
        }
      }
    });
  }

  
}
