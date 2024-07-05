import 'package:etechstore/module/payment/controllers/payment_controller.dart';
import 'package:etechstore/module/payment/models/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentTile extends StatelessWidget {
  const PaymentTile({super.key, required this.paymentMethod});
  final PaymentModel paymentMethod;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentController());
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      onTap: () {
        controller.selectedPaymentMethod.value = paymentMethod;
        Navigator.pop(context);
      },
      leading: SizedBox(
        width: 60,
        height: 40,
        child: Image(
          image: AssetImage(paymentMethod.icon),
          fit: BoxFit.contain,
        ),
      ),
      title: Text(paymentMethod.ten),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
