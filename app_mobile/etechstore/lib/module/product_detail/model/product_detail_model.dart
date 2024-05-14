import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  int id;
  String KhuyenMai;
  String moTa;
  int maLoaiSanPham;
  int soLuong;
  String ten;
  bool trangThai;
  String giaTien;
  // String mauSac;
  int maDanhMuc;
  List<dynamic> hinhAnh;
  String thumbnail;

  ProductModel({
    required this.thumbnail,
    required this.hinhAnh,
    required this.maDanhMuc,
    required this.id,
    // required this.mauSac,
    required this.KhuyenMai,
    required this.moTa,
    required this.maLoaiSanPham,
    required this.soLuong,
    required this.ten,
    required this.trangThai,
    required this.giaTien,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        thumbnail: json['thumbnail'],
        hinhAnh: json['HinhAnh'] as List<dynamic>,
        maDanhMuc: json['MaDanhMuc'],
        // mauSac: json['MauSac'],
        giaTien: json['GiaTien'],
        id: json['id'],
        KhuyenMai: json['KhuyenMai'],
        maLoaiSanPham: json['MaLoaiSanPham'],
        moTa: json['MoTa'],
        soLuong: json['SoLuong'],
        ten: json['Ten'],
        trangThai: json['TrangThai'],
      );

  Map<String, dynamic> toJson() {
    final json = {
      'thumbnail': thumbnail,
      'HinhAnh': hinhAnh,
      'MaDanhMuc': maDanhMuc,
      //'MauSac': mauSac,
      'GiaTien': giaTien,
      'id': id,
      'KhuyenMai': KhuyenMai,
      'MaLoaiSanPham': maLoaiSanPham,
      'MoTa': moTa,
      'SoLuong': soLuong,
      'Ten': ten,
      'TrangThai': trangThai,
    };
    return json;
  }

  factory ProductModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return ProductModel(
      thumbnail: document['thumbnail'],
      hinhAnh: document['HinhAnh'],
      maDanhMuc: document['MaDanhMuc'],
      id: document['id'],
      //   mauSac: document['MauSac'],
      KhuyenMai: document['KhuyenMai'],
      moTa: document['MoTa'],
      maLoaiSanPham: document['MaLoaiSanPham'],
      soLuong: document['SoLuong'],
      ten: document['Ten'],
      trangThai: document['TrangThai'],
      giaTien: document['GiaTien'],
    );
  }
}
