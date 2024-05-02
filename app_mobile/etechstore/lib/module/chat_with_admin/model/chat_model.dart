import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final Timestamp thoiGianNhan;
  final String trangThai;
  final String maKhachHang;
  final String noiDung;

  Message({
    required this.maKhachHang,
    required this.trangThai,
    required this.noiDung,
    required this.thoiGianNhan,
    required this.id,
  });

  Map<String, dynamic> json() {
    return {
      'id': id,
      'uid': trangThai,
      'ThoiGianNhan': thoiGianNhan,
      'MaKhachHang': maKhachHang,
      'NoiDung': noiDung,
    };
  }
}
