import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String HoTen;
  String Email;
  String Password;
  int SoDienThoai;
  final String HinhDaiDien;
  bool Quyen;
  int TrangThai;
  String DiaChi;

  UserModel({
    required this.uid,
    required this.DiaChi,
    required this.Email,
    required this.HinhDaiDien,
    required this.HoTen,
    required this.Password,
    required this.Quyen,
    required this.SoDienThoai,
    required this.TrangThai,
  });

  static empty() => UserModel(
      uid: '',
      DiaChi: '',
      Email: '',
      HinhDaiDien: '',
      HoTen: '',
      Password: '',
      Quyen: false,
      SoDienThoai: 0,
      TrangThai: 0);

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      //Map Json to Model
      return UserModel(
          uid: data['uid'],
          DiaChi: data['DiaChi'] ?? '',
          Email: data['Email'] ?? '',
          HinhDaiDien: data['HinhDaiDien'] ?? '',
          HoTen: data['HoTen'] ?? 0,
          Password: data['Password'] ?? '',
          Quyen: data['Quyen'] ?? false,
          SoDienThoai: data['SoDienThoai'] ?? 0,
          TrangThai: data['TrangThai'] ?? false);
    } else {
      return UserModel.empty();
    }
  }
}
