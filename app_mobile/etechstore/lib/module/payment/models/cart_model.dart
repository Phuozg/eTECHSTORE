import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  String id;
  String maKhachHang;
  int soLuong;
  int trangThai;
  String maSanPham;

  CartModel({
    required this.id,
    required this.maKhachHang,
    required this.soLuong,
    required this.trangThai,
    required this.maSanPham,
  });

  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'maKhachHang': maKhachHang,
      'soLuong': soLuong,
      'trangThai': trangThai,
      'mauSanPham': maSanPham,
    };
  }

  factory CartModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    return CartModel(
      id: document['id']??'',
      maKhachHang: document['maKhachHang']??'',
      soLuong: document['soLuong']??0,
      trangThai: document['trangThai']??0,
      maSanPham: document['mauSanPham']['maSanPham']??'',
    );
  }

}
