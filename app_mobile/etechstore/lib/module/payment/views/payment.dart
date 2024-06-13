import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/payment/controllers/payment_controller.dart';
import 'package:etechstore/module/payment/controllers/order_items_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Payment extends StatelessWidget {
  const Payment({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentController());
    final orderController = Get.put(OrderItemsController());
    return Obx(()=> Column(
      children: [
        GestureDetector(
          onTap: (){
          controller.selectPaymentMethod(context);
        },
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Phương thức thanh toán",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  Text("Thay đổi")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image(image: AssetImage(controller.selectedPaymentMethod.value.icon,),fit: BoxFit.contain,height: 60,),
                  const VerticalDivider(),
                  Text(controller.selectedPaymentMethod.value.ten),
                ],
              ),
            ],
          ),
        ),
        const Divider(),
        Text("Tổng tiền: ${priceFormat(CartController().instance.totalPrice.value.toInt())}",style: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
      ],
    )
    );
  }
}