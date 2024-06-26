import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  String id;
  String maKhachHang;
  int soLuong;
  int trangThai;
  Map<String, dynamic> maSanPham;

  CartModel({
    required this.id,
    required this.maKhachHang,
    required this.soLuong,
    required this.trangThai,
    required this.maSanPham,
  });

  factory CartModel.fromMap(Map<String, dynamic> data) {
    return CartModel(
      id: data['id'],
      maKhachHang: data['maKhachHang'],
      soLuong: data['soLuong'],
      trangThai: data['trangThai'],
      maSanPham: data['mauSanPham'],
    );
  }

factory CartModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return CartModel(
      id: data['id'],
      maKhachHang: data['maKhachHang'],
      soLuong: data['soLuong'],
      trangThai: data['trangThai'],
      maSanPham: data['mauSanPham'],
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'maKhachHang': maKhachHang,
      'soLuong': soLuong,
      'trangThai': trangThai,
      'mauSanPham': maSanPham,
    };
  }
}
