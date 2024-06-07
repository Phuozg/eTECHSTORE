import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel{
  String HinhAnh;
  bool TrangThai;
  String MaSanPham;

  BannerModel({
    required this.HinhAnh,
    required this.MaSanPham,
    required this.TrangThai
  });

  //empty Banner
  static BannerModel empty()=>BannerModel(HinhAnh: '', MaSanPham: '', TrangThai: false);

  factory BannerModel.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> document){
    if(document.data()!=null){
      final data = document.data()!;

      //Map Json to Model
      return BannerModel(
        HinhAnh: data['HinhAnh']??'',
        MaSanPham: data['MaSanPham']??'',
        TrangThai: data['TrangThai']??false
      );
    } else {
      return BannerModel.empty();
    }
  }
}