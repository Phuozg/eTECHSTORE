import 'package:cloud_firestore/cloud_firestore.dart';

class ProductSampleModel {
  String id;
  String MaSanPham;
  int soLuong;
  List<String> mauSac;
  List<String> cauHinh;
  Map<String, int> giaTien;

  ProductSampleModel({
    required this.id,
    required this.soLuong,
    required this.mauSac,
    required this.cauHinh,
    required this.MaSanPham,
    required this.giaTien,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'SoLuong': soLuong,
      'MauSac': mauSac,
      'CauHinh': cauHinh,
      'MaSanPham': MaSanPham,
    };
  }

  factory ProductSampleModel.fromMap(Map<String, dynamic> map) {
    return ProductSampleModel(
      id: map['id'],
      soLuong: map['SoLuong'],
      mauSac: map['MauSac'],
      cauHinh: map['CauHinh'],
      MaSanPham: map['MaSanPham'],
      giaTien: Map<String, int>.from(map['GiaTien'] ?? {}),
    );
  }

  factory ProductSampleModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ProductSampleModel(
      id: doc.id,
      MaSanPham: data['MaSanPham'] ?? '',
      soLuong: data['SoLuong'] ?? 0,
      mauSac: List<String>.from(data['MauSac'] ?? []),
      cauHinh: List<String>.from(data['CauHinh'] ?? []),
      giaTien: Map<String, int>.from(data['GiaTien'] ?? {}),
    );
  }
}
