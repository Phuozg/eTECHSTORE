import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/home/models/banner_model.dart';
import 'package:get/get.dart';

class BannerController extends GetxController{
  static BannerController get instance => Get.find();

   final db = FirebaseFirestore.instance;
  var allBanner = <BannerModel>[].obs;
  @override
  void onInit(){
    fetchBanner();
    super.onInit();
  }

  Future<void> fetchBanner() async {
    //fetch all product
    final snapshot = await db.collection('KhuyenMaiBanner').where('TrangThai',isEqualTo: true).get();
    final banners = snapshot.docs.map((document) => BannerModel.fromSnapshot(document)).toList();
    allBanner.assignAll(banners);
  }
}