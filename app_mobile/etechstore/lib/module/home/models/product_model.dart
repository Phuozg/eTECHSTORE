import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel{
  String id;
  String Ten;
  String MoTa;
  String thumbnail;
  List<dynamic> HinhAnh;
  int GiaTien;
  int KhuyenMai;
  int MaDanhMuc;
  bool isPopular;
  bool TrangThai;
  
  ProductModel({
    required this.id,
    required this.Ten,
    required this.MoTa,
    required this.thumbnail,
    required this.HinhAnh,
    required this.GiaTien,
    required this.KhuyenMai,
    required this.MaDanhMuc,
    required this.isPopular,
    required this.TrangThai
  });

  //Empty Product
  static ProductModel empty() => ProductModel(id: '', Ten: '', MoTa: '', thumbnail: '', HinhAnh: [], GiaTien: 0, KhuyenMai: 0, MaDanhMuc: 0,isPopular: false, TrangThai: false);

  //
  factory ProductModel.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> document){
    if(document.data()!=null){
      final data = document.data()!;

      //Map Json to Model
      return ProductModel(
        id: document.id, 
        Ten: data['Ten']??'', 
        MoTa: data['MoTa']??'', 
        thumbnail: data['thumbnail']??'', 
        HinhAnh: data['DSHinhAnh']??[], 
        GiaTien: data['GiaTien']??'', 
        KhuyenMai: data['KhuyenMai']??'', 
        MaDanhMuc: data['MaDanhMuc']??0, 
        isPopular: data['isPopular']??false,
        TrangThai: data['TrangThai']??false
      );
    } else {
      return ProductModel.empty();
    }
  }
}