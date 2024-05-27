class ProductSampleModel {
  String id;
  String MaSanPham;
  int soLuong;
  List<String> mauSac;
  List<String> cauHinh;

  ProductSampleModel({
    required this.id,
    required this.soLuong,
    required this.mauSac,
    required this.cauHinh,
    required this.MaSanPham,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'SoLuong': soLuong,
      'MauSac': mauSac,
      'CauHinh': cauHinh,
      'MaSanPham': MaSanPham,
    };
  }

  factory ProductSampleModel.fromMap(Map<String, dynamic> map) {
    return ProductSampleModel(
      id: map['id'],
      soLuong: map['SoLuong'],
      mauSac: map['MauSac'],
      cauHinh: map['CauHinh'],
      MaSanPham: map['MaSanPham'],
    );
  }

    factory ProductSampleModel.fromFirestore(Map<String, dynamic> data) {
    return ProductSampleModel(
      id: data['id'] ?? '',
      MaSanPham: data['MaSanPham'] ?? '',
      soLuong: data['SoLuong'] ?? 0,
      mauSac: List<String>.from(data['MauSac'] ?? []),
      cauHinh: List<String>.from(data['CauHinh'] ?? []),
    );
  }
}
