import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/payment/controllers/order_controller.dart';
import 'package:etechstore/module/previews/models/preview_model.dart';
import 'package:etechstore/module/previews/models/user_model.dart';
import 'package:get/get.dart';

class PreviewsController extends GetxController {
  static PreviewsController get instance => Get.find();
  final db = FirebaseFirestore.instance;
  RxList<PreviewModel> previewsOfProduct = <PreviewModel>[].obs;
  RxList<UserModel> user = <UserModel>[].obs;
  RxInt selectedstar = RxInt(-1);
  void selectStar(int index) {
    selectedstar.value = index;
  }

  Future<void> fetchPreviews(String MaSanPham) async {
    try {
      final snapshot = await db
          .collection('DanhGia')
          .where('MaSanPham', isEqualTo: MaSanPham)
          .get();
      final previews =
          snapshot.docs.map((doc) => PreviewModel.fromSnapshot(doc)).toList();
      previewsOfProduct.assignAll(previews);
    } catch (e) {
      throw 'Something wrong';
    }
  }


Future<void> fetchUser() async {
    db.collection("Users").where("TrangThai", isEqualTo: true).get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          user.add(UserModel.fromSnapshot(docSnapshot));
        }
      },
    );
  }


  num getAverage() {
    num average = 0;
    previewsOfProduct.forEach((preview) {
      average += preview.SoSao;
    });
    if (previewsOfProduct.isEmpty) {
      return 0;
    }
    average /= previewsOfProduct.length;
    return average;
  }

  Future<void> addPreview(
      String previewUser, int star, String userID, String productID) async {
    final id = generateRandomString(20);
    final preview = PreviewModel(
        id: id,
        MaKhachHang: userID,
        MaSanPham: productID,
        DanhGia: previewUser,
        SoSao: star + 1,
        TrangThai: true);
    db.collection('DanhGia').doc(id).set(preview.toJson());
  }
}
