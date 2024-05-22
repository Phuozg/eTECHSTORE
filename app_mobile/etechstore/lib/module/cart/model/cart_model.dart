import 'package:etechstore/module/product_detail/model/product_model.dart';

class CartModel {
  final String maGioHang;
  final maSanPham;
  final int soLuong;
  final String id;
  final String maKhachHang;

  CartModel({
    required this.maGioHang,
    required this.maSanPham,
    required this.soLuong,
    required this.id,
    required this.maKhachHang,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        maKhachHang: json['maKhachHang'],
        maGioHang: json['MaGioHang'],
        maSanPham: json['MaSanPham'],
        soLuong: json['SoLuong'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() {
    final json = {
      'MaGioHang': maGioHang,
      'MaSanPham': maSanPham,
      'SoLuong': soLuong,
      'id': id,
      'MaKhachHang':maKhachHang
    };
    return json;
  }
}
