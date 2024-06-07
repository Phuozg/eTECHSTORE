class ModelProductModel{
  String CauHinh;
  String MaSanPham;
  String MauSac;

  ModelProductModel({
    required this.CauHinh,
    required this.MaSanPham,
    required this.MauSac
  });

  Map<String, dynamic> toJson() {
    return {
      'CauHinh':CauHinh,
      'MaSanPham':MaSanPham,
      'MauSac':MauSac
    };
  }

  factory ModelProductModel.fromJson(Map<String,dynamic> json){
    return ModelProductModel(
      CauHinh: json['CauHinh'], 
      MaSanPham: json['MaSanPham'], 
      MauSac: json['MauSac']
    );
  }
}