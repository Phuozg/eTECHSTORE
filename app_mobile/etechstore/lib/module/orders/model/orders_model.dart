import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersModel {
  final String id;
  final Timestamp ngayTaoDon;
  final String maKhachHang;
  final int tongTien;
  final bool isPaid;
  final bool isBeingShipped;
  final bool isShipped;
  final bool isCompleted;
  final bool isCancelled;

  OrdersModel({
    required this.id,
    required this.ngayTaoDon,
    required this.maKhachHang,
    required this.tongTien,
    required this.isPaid,
    required this.isBeingShipped,
    required this.isShipped,
    required this.isCompleted,
    required this.isCancelled,
  });

  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    return OrdersModel(
      id: json['id'],
      ngayTaoDon: (json['NgayTaoDon']),
      maKhachHang: json['MaKhachHang'],
      tongTien: json['TongTien'],
      isPaid: json['isPaid'] ?? false,
      isBeingShipped: json['isBeingShipped'] ?? false,
      isShipped: json['isShipped'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      isCancelled: json['isCancelled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'NgayTaoDon': ngayTaoDon,
      'MaKhachHang': maKhachHang,
      'TongTien': tongTien,
      'isPaid': isPaid,
      'isBeingShipped': isBeingShipped,
      'isShipped': isShipped,
      'isCompleted': isCompleted,
      'isCancelled': isCancelled,
    };
  }
}
