import 'package:cloud_firestore/cloud_firestore.dart';

class ProductSampleModel {
  String id;
  String MaSanPham;
  int soLuong;
  List<String> mauSac;
  List<String> cauHinh;
  List<int> giaTien;

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
      'GiaTien': giaTien,
    };
  }

  factory ProductSampleModel.fromMap(Map<String, dynamic> map) {
    return ProductSampleModel(
      id: map['id'],
      soLuong: map['SoLuong'],
      mauSac: List<String>.from(map['MauSac'] ?? []),
      cauHinh: List<String>.from(map['CauHinh'] ?? []),
      MaSanPham: map['MaSanPham'],
      giaTien: List<int>.from(map['GiaTien'] ?? []),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'MaSanPham': MaSanPham,
      'SoLuong': soLuong,
      'MauSac': mauSac,
      'CauHinh': cauHinh,
      'GiaTien': giaTien,
    };
  }

  factory ProductSampleModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ProductSampleModel(
      id: doc.id,
      MaSanPham: data['MaSanPham'] ?? '',
      soLuong: data['SoLuong'] ?? 0,
      mauSac: List<String>.from(data['MauSac'] ?? []),
      cauHinh: List<String>.from(data['CauHinh'] ?? []),
      giaTien: List<int>.from(data['GiaTien'] ?? []),
    );
  }
}
