import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel{
  int id;
  String TenDanhMuc;
  String MoTa;
  String HinhAnh;
  int TrangThai;

  CategoryModel({
    required this.id,
    required this.TenDanhMuc,
    required this.MoTa,
    required this.HinhAnh,
    required this.TrangThai
  });

  //Empty Category
  static CategoryModel empty() => CategoryModel(id: 0, TenDanhMuc: '', MoTa: '', HinhAnh: '', TrangThai: 0);

  factory CategoryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      //Map Json to Model
      return CategoryModel(
          id: data['id'],
          TenDanhMuc: data['TenDanhMuc'] ?? '',
          MoTa: data['MoTa'] ?? '',
          HinhAnh: data['HinhAnh'] ?? '',
          TrangThai: data['TrangThai'] ?? 0);
    } else {
      return CategoryModel.empty();
    }
  }
}