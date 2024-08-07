import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String id;
  int TongTien;
  Timestamp NgayTaoDon;
  String MaKhachHang;
  bool isPaid;
  bool isBeingShipped;
  bool isShipped;
  bool isCompleted;
 
  OrderModel(
      {required this.id,
      required this.TongTien,
      required this.NgayTaoDon,
      required this.MaKhachHang,
      required this.isPaid,
      required this.isBeingShipped,
      required this.isShipped,
      required this.isCompleted,
      });

  //Empty orther
  static OrderModel empty() => OrderModel(
      id: '',
      TongTien: 0,
      NgayTaoDon: Timestamp.now(),
      MaKhachHang: '',
      isPaid: false,
      isBeingShipped: false,
      isShipped: false,
      isCompleted: false,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'TongTien': TongTien,
      'NgayTaoDon': NgayTaoDon,
      'MaKhachHang': MaKhachHang,
      'isPaid': isPaid,
      'isBeingShipped': isBeingShipped,
      'isShipped': isShipped,
      'isCompleted': isCompleted,
     
    };
  }

  factory OrderModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      //Map Json to Model
      return OrderModel(
          id: document.id,
          TongTien: data['TongTien'] ?? 0,
          NgayTaoDon: data['NgayTaoDon'] ?? Timestamp.now(),
          MaKhachHang: data['MaKhachHang'] ?? '',
          isPaid: data['isPaid'] ?? false,
          isBeingShipped: data['isBeingShipped'] ?? false,
          isShipped: data['isShipped'] ?? false,
          isCompleted: data['isCompleted'] ?? false,
          );
    } else {
      return OrderModel.empty();
    }
  }
}
