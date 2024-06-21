import 'package:cloud_firestore/cloud_firestore.dart';

class PreviewModel {
  String id;
  String MaKhachHang;
  String MaSanPham;
  String DanhGia;
  int SoSao;
  bool TrangThai;

  PreviewModel(
      {required this.id,
      required this.MaKhachHang,
      required this.MaSanPham,
      required this.DanhGia,
      required this.SoSao,
      required this.TrangThai});

  static empty() => PreviewModel(
      id: '',
      MaKhachHang: '',
      MaSanPham: '',
      DanhGia: '',
      SoSao: 0,
      TrangThai: false);

  factory PreviewModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      //Map Json to Model
      return PreviewModel(
          id: data['id'],
          MaKhachHang: data['MaKhachHang'] ?? '',
          MaSanPham: data['MaSanPham'] ?? '',
          DanhGia: data['DanhGia'] ?? '',
          SoSao: data['SoSao'] ?? 0,
          TrangThai: data['TrangThai'] ?? false);
    } else {
      return PreviewModel.empty();
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'MaKhachHang': MaKhachHang,
      'MaSanPham': MaSanPham,
      'DanhGia': DanhGia,
      'SoSao': SoSao,
      'TrangThai': TrangThai,
    };
  }
}
