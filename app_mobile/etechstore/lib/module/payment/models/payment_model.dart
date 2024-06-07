class PaymentModel{
  String ten;
  String icon;

  PaymentModel({
    required this.ten,
    required this.icon
  });

  static PaymentModel empty()=> PaymentModel(ten: '', icon: '');
}
