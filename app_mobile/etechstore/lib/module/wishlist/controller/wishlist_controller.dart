import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/home/models/product_model.dart';
import 'package:etechstore/module/payment/controllers/order_controller.dart';
import 'package:etechstore/module/wishlist/model/wishlist_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class WishListController extends GetxController{
  static WishListController get intance => Get.find();

  final db = FirebaseFirestore.instance;
  final userID = FirebaseAuth.instance.currentUser!.uid;
  RxList<WishList> wishList = <WishList>[].obs;
  RxList<ProductModel> listProduct = <ProductModel>[].obs;
  RxList<ProductModel> listProductWishList = <ProductModel>[].obs;
  var id = generateRandomString(20);
  @override
  void onInit(){
    fetchWishList();
    super.onInit();
  }

  Future<void> fetchWishList() async {

    final products = await db.collection('SanPham').where('TrangThai', isEqualTo: true).get();
    final items = products.docs.map((document) => ProductModel.fromSnapshot(document)).toList();
    listProduct.addAll(items);
    db.collection('YeuThich').where('MaKhachHang',isEqualTo: userID).snapshots().listen((snapshot) async {
      wishList = snapshot.docs.map((doc)=>WishList.fromSnapshot(doc)).toList().obs;
      listProductWishList.clear();
      wishList.forEach((wish) {
        wish.DSSanPham.forEach((productID) {
          for(var product in listProduct){
            if(product.id == productID) listProductWishList.add(product);
          }
        });
      });
    });
  }
  bool isWish(String productID) {
    bool isWish = false;
    listProductWishList.forEach((wish) {
      if(wish.id==productID){
        isWish = true;
      }
    });
    return isWish;
  }

  Future<void> addWish(String productID) async {
    List<dynamic> addWish;
    wishList.forEach((wish) {
      if(wish.MaKhachHang==userID){
        addWish = wish.DSSanPham;
        addWish.add(productID);
        db.collection('YeuThich').doc(userID).update(
          {('DSSanPham'):addWish}
        );
      }
    });
  }
  Future<void> removeWish(String productID) async {
    List<dynamic> removeWish;
    wishList.forEach((wish) {
      if(wish.MaKhachHang==userID){
        removeWish = wish.DSSanPham;
        removeWish.remove(productID);
        db.collection('YeuThich').doc(userID).update(
          {('DSSanPham'):removeWish}
        );
      }
    });
    listProductWishList.removeWhere((product) => product.id==productID);
  }

  Future<void> createWishList(String UserID) async {
    final wishRef = await db.collection('YeuThich').doc(UserID).get();
    if(!wishRef.exists){
      await db.collection('YeuThich').doc(UserID).set({
        'DSSanPham':[],
        'MaKhachHang':UserID
      });
    }
  }
}