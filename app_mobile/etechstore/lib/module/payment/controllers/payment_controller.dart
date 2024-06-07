import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/payment/models/payment_model.dart';
import 'package:etechstore/module/payment/views/payment_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController{
  static PaymentController get instance => Get.find();

  final db = FirebaseFirestore.instance;
  
  final Rx<PaymentModel> selectedPaymentMethod = PaymentModel.empty().obs;

  @override 
  void onInit(){
    selectedPaymentMethod.value = PaymentModel(ten: 'Thanh toán khi nhận hàng', icon: 'assets/icons/logo-cod.png');
    super.onInit();
  }

  Future<dynamic> selectPaymentMethod(BuildContext context){
    return showModalBottomSheet(
      context: context, 
      builder: (_)=>SingleChildScrollView(
        child: Container( 
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PaymentTile(paymentMethod: PaymentModel(ten: 'Thanh toán khi nhận hàng', icon: 'assets/icons/logo-cod.png')),
              const SizedBox(height: 10,),
              PaymentTile(paymentMethod: PaymentModel(ten: 'VNPay', icon: 'assets/icons/vnpay-logo.png')),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      )
    );
  }
}