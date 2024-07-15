import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  String HinhAnh;
  bool TrangThai;
  String MaSanPham;
  int DanhMuc;

  BannerModel(
      {required this.HinhAnh,
      required this.MaSanPham,
      required this.TrangThai,
      required this.DanhMuc});

  //empty Banner
  static BannerModel empty() =>
      BannerModel(HinhAnh: '', MaSanPham: '', TrangThai: false, DanhMuc: 0);

  factory BannerModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      //Map Json to Model
      return BannerModel(
          HinhAnh: data['HinhAnh'] ?? '',
          MaSanPham: data['MaSanPham'] ?? '',
          TrangThai: data['TrangThai'] ?? false,
          DanhMuc: data['DanhMuc'] ?? 0);
    } else {
      return BannerModel.empty();
    }
  }
}
