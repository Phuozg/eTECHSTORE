class DetailOrders {
  final Map<String, dynamic> maMauSanPham;
  final String maDonHang;
  final int soLuong;
  final int? khuyenMai;
  final int? trangThai;
  final int? giaTien;

  DetailOrders({
    required this.giaTien,
    required this.maMauSanPham,
    required this.maDonHang,
    required this.soLuong,
    required this.khuyenMai,
    required this.trangThai,
  });

  factory DetailOrders.fromJson(Map<String, dynamic> json) {
    return DetailOrders(
giaTien: json['GiaTien']??0,
      maMauSanPham: json['MaMauSanPham'],
      maDonHang: json['MaDonHang'] as String,
      soLuong: json['SoLuong'],
      khuyenMai: json['KhuyenMai'] as int?,
      trangThai: json['TrangThai'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'GiaTien':giaTien,
      'MaMauSanPham': maMauSanPham,
      'MaDonHang': maDonHang,
      'SoLuong': soLuong,
      'KhuyenMai': khuyenMai,
      'TrangThai': trangThai,
    };
  }
}
