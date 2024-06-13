class DetailOrders {
  Map<String, dynamic> maMauSanPham;
  String maDonHang;
  int soLuong;
  int khuyenMai;
  int trangThai;

  DetailOrders({
    required this.maMauSanPham,
    required this.maDonHang,
    required this.soLuong,
    required this.khuyenMai,
    required this.trangThai,
  });

  factory DetailOrders.fromJson(Map<String, dynamic> json) {
    return DetailOrders(
      maMauSanPham: json['MaMauSanPham'],
      maDonHang: json['MaDonHang'] as String,
      soLuong: json['SoLuong'] as int,
      khuyenMai: json['KhuyenMai'] as int,
      trangThai: json['TrangThai'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaMauSanPham': maMauSanPham,
      'MaDonHang': maDonHang,
      'SoLuong': soLuong,
      'KhuyenMai': khuyenMai,
      'TrangThai': trangThai,
    };
  }
}
