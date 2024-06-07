import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/home/models/category_model.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController{
  static CategoryController get instance => Get.find();

  final db = FirebaseFirestore.instance;
  var allCategories = <CategoryModel>[].obs;

  @override
  void onInit(){
    fetchCategories();
    super.onInit();
  }

  Future<void> fetchCategories() async {
    try{
      final snapshot = await db.collection('DanhMucSanPham').where('TrangThai',isEqualTo: 1).get();
      final categories = snapshot.docs.map((document) => CategoryModel.fromSnapshot(document)).toList();
      allCategories.assignAll(categories);
    }
    catch (e){
      throw 'Something wrong';
    }
  }
}
