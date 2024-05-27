class Promotion {
  final String id;
  final String ten;
  final String moTa;
  final int phanTramKhuyenMai;
  final DateTime ngayBD;
  final DateTime ngayKT;
  final int trangThai;

  const Promotion({
    required this.id,
    required this.ten,
    required this.moTa,
    required this.phanTramKhuyenMai,
    required this.ngayBD,
    required this.ngayKT,
    required this.trangThai,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'] as String,
      ten: json['Ten'] as String,
      moTa: json['MoTa'] as String,
      phanTramKhuyenMai: json['PhanTramKhuyenMai'] as int,
      ngayBD: DateTime.parse(json['NgayBD'] as String),
      ngayKT: DateTime.parse(json['NgayKT'] as String),
      trangThai: json['TrangThai'] as int,
    );
  }

  @override
  String toString() {
    return 'Promotion{id: $id, ten: $ten, moTa: $moTa, phanTramKhuyenMai: $phanTramKhuyenMai, ngayBD: $ngayBD, ngayKT: $ngayKT, trangThai: $trangThai}';
  }
}
