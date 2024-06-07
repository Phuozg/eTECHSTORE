import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItemModel{
  String id;
  String MaDonHang;
  String MaMauSanPham;
  int SoLuong;
  int KhuyenMai;
  int TrangThai;

  OrderItemModel({
    required this.id,
    required this.MaDonHang,
    required this.MaMauSanPham,
    required this.SoLuong,
    required this.KhuyenMai,
    required this.TrangThai
  });

  //Empty 
  static OrderItemModel empty()=> OrderItemModel(id: '', MaDonHang: '', MaMauSanPham: '', SoLuong: 0, KhuyenMai: 0, TrangThai: 0);

  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'MaDonHang':MaDonHang,
      'MaMauSanPham':MaMauSanPham,
      'SoLuong':SoLuong,
      'KhuyenMai':KhuyenMai,
      'TrangThai':TrangThai
    };
  }

  factory OrderItemModel.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> document){
     if(document.data()!=null){
      final data = document.data()!;

      //Map Json to Model
      return OrderItemModel(
        id: document.id, 
        MaDonHang: data['MaDonhang']??'',
        MaMauSanPham: data['MaMauSanPham']??'',
        SoLuong: data['SoLuong']??0,
        KhuyenMai: data['KhuyenMai']??0,
        TrangThai: data['TrangThai']??0
      );
    } else {
      return OrderItemModel.empty();
    }
  }
}
