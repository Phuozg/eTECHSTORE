import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/payment/models/model_product_model.dart';

class OrderDetail {
  String MaDonHang;
  int SoLuong;
  int TrangThai;
  int KhuyenMai;
  Map<String,dynamic> MaMauSanPham;


  OrderDetail({
    required this.MaDonHang,
    required this.SoLuong,
    required this.TrangThai,
    required this.KhuyenMai,
    required this.MaMauSanPham,
  });

  
  Map<String, dynamic> toJson() {
    return {
      'MaDonHang': MaDonHang,
      'KhuyenMai':KhuyenMai,
      'SoLuong': SoLuong,
      'TrangThai': TrangThai,
      'MaMauSanPham': MaMauSanPham
    };
  }

  factory OrderDetail.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    return OrderDetail(
      MaDonHang: document['MaDonHang']??'',
      SoLuong: document['SoLuong']??0,
      TrangThai: document['TrangThai']??0,
      KhuyenMai: document['KhuyenMai']??0,
      MaMauSanPham: document['MaMauSanPham'].map((valueData)=>ModelProductModel.fromJson(valueData as Map<String,dynamic>)),
    );
  }

}
