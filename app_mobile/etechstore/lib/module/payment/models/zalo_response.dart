class ZaloResponse {
  final String zptranstoken;
  final String orderurl;
  final int returncode;
  final String returnmessage;
  final int subreturncode;
  final String subreturnmessage;
  final String ordertoken;

  ZaloResponse(
      {required this.zptranstoken,
      required this.orderurl,
      required this.returncode,
      required this.returnmessage,
      required this.subreturncode,
      required this.subreturnmessage,
      required this.ordertoken});

  factory ZaloResponse.fromJson(Map<String, dynamic> json) {
    return ZaloResponse(
      zptranstoken: json['zp_trans_token'] ?? '',
      orderurl: json['order_url'] ?? '',
      returncode: json['return_code'] ?? 0,
      returnmessage: json['return_message'] ?? '',
      subreturncode: json['sub_return_code'] ?? 0,
      subreturnmessage: json['sub_return_message'] ?? '',
      ordertoken: json["order_token"] ?? '',
    );
  }
}
