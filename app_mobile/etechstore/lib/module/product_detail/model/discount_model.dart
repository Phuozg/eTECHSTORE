import 'package:cloud_firestore/cloud_firestore.dart';

class DiscountModel {
  String id;
   Timestamp ngayBD;
  Timestamp ngayKT;
  int phanTramKhuyenMai;
  String ten;
  int trangThai;

  DiscountModel({
    required this.id,
     required this.ngayBD,
    required this.ngayKT,
    required this.phanTramKhuyenMai,
    required this.ten,
    required this.trangThai,
  });

  // fromJson method
  factory DiscountModel.fromJson(Map<String, dynamic> json,) {
    return DiscountModel(
      id: json['id'],
       ngayBD: json['NgayBD'] as Timestamp,
      ngayKT: json['NgayKT'] as Timestamp,
      phanTramKhuyenMai: json['PhanTramKhuyenMai'] as int,
      ten: json['Ten'] as String,
      trangThai: json['TrangThai'] as int,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
       'NgayBD': ngayBD,
      'NgayKT': ngayKT,
      'PhanTramKhuyenMai': phanTramKhuyenMai,
      'Ten': ten,
      'TrangThai': trangThai,
    };
  }
}
