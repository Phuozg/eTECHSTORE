import 'package:cloud_firestore/cloud_firestore.dart';

class WishList{
  String MaKhachHang;
  List<dynamic> DSSanPham;

  WishList({
    required this.MaKhachHang,
    required this.DSSanPham
  });

  //Empty Product
  static WishList empty() => WishList(MaKhachHang: '', DSSanPham: []);

  //
  factory WishList.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> document){
    if(document.data()!=null){
      final data = document.data()!;

      //Map Json to Model
      return WishList(
        MaKhachHang: data['MaKhachHang']??'',
        DSSanPham: data['DSSanPham']??''
      );
    } else {
      return WishList.empty();
    }
  }
}