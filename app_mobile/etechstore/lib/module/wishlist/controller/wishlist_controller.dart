import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/home/models/product_model.dart';
import 'package:etechstore/module/wishlist/model/wishlist_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class WishListController extends GetxController{
  static WishListController get intance => Get.find();

  final db = FirebaseFirestore.instance;
  final userID = FirebaseAuth.instance.currentUser!.uid;
  RxList<WishList> allWishList = <WishList>[].obs;
  List<ProductModel> listProductWishList = [];
  @override
  void onInit(){
    fetchWishList();
    super.onInit();
  }

  Future<void> fetchWishList() async {
    //fetch all product
    final snapshot = await db.collection('YeuThich').where('MaKhachHang',isEqualTo: userID).get();
    final products = snapshot.docs.map((document) => WishList.fromSnapshot(document)).toList();
    allWishList.assignAll(products);
  }

  Future<void> fetchProductWishList() async{
    allWishList.forEach((element) async {
      await db.collection('SanPham').doc(element.DSSanPham.toString()).get().then(
        (value) {
          print(value.data());
        }
      );
    });
  }

}