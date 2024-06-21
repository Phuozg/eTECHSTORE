import 'package:etechstore/module/home/models/product_model.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/payment/controllers/order_controller.dart';
import 'package:etechstore/module/payment/controllers/payment_controller.dart';
import 'package:etechstore/module/payment/views/address_user.dart';
import 'package:etechstore/module/sample/product_horizontal_listtile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyNowScreen extends StatelessWidget {
  const BuyNowScreen({super.key,required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final paymentController = Get.put(PaymentController());
    final orderController = Get.put(OrderController());
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          color: const Color(0xFF383CA0),
        ),
        title: const Text(
          'Thanh toán',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          address(userID),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: productHorizontalListTile(context, product)
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(color: Color(0xFF383CA0), spreadRadius: 1),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(()=> Column(
                children: [
                  GestureDetector(
                    onTap: (){
                    paymentController.selectPaymentMethod(context);
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
                            Image(image: AssetImage(paymentController.selectedPaymentMethod.value.icon,),fit: BoxFit.contain,height: 60,),
                            const VerticalDivider(),
                            Text(paymentController.selectedPaymentMethod.value.ten),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Text("Tổng tiền: ${priceFormat((product.GiaTien-(product.GiaTien*product.KhuyenMai/100)).toInt())}",style: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                ],
              )
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
            onPressed: () {
              if (paymentController.selectedPaymentMethod.value.ten == 'VNPay') {
              } else {
                orderController.processOrderBuyNow(userID, (product.GiaTien-(product.GiaTien*product.KhuyenMai/100)).toInt(),(product.GiaTien*product.KhuyenMai~/100).toInt(),product);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF383CA0)),
            child:Text(
                'Đặt hàng \n ${priceFormat((product.GiaTien-(product.GiaTien*product.KhuyenMai/100)).toInt())}',
                style: const TextStyle(color: Colors.white, fontSize: 15),
                textAlign: TextAlign.center,
              )
          ),
      )
    );
  }
}