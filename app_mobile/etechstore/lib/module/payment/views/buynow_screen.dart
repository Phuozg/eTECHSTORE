import 'dart:convert';

import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/payment/controllers/order_controller.dart';
import 'package:etechstore/module/payment/controllers/payment_controller.dart';
import 'package:etechstore/module/payment/controllers/vnpay_payment_controller.dart';
import 'package:etechstore/module/payment/controllers/zalo_pay_controller.dart';
import 'package:etechstore/module/payment/views/address_user.dart';
import 'package:etechstore/module/payment/views/vnpay_buynow_screen.dart';
import 'package:etechstore/module/payment/views/vnpay_screen.dart';
import 'package:etechstore/module/payment/views/zalo_buynow_screen.dart';
import 'package:etechstore/module/payment/views/zalo_screen.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:etechstore/module/sample/product_horizontal_listtile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BuyNowScreen extends StatelessWidget {
  const BuyNowScreen(
      {super.key,
      required this.productID,
      required this.quantity,
      required this.price,
      required this.color,
      required this.config});
  final String productID;
  final int quantity;
  final String price;
  final String color;
  final String config;
  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final paymentController = Get.put(PaymentController());
    final orderController = Get.put(OrderController());

    final vnPayController = Get.put(VNPAY());
    orderController.getProductByID();

    final zalo = Get.put(ZaloPay());
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
          leading: const BackButton(
            color: Colors.white,
          ),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: orderController.productReturn.map((element) {
              return element.id == productID
                  ? Column(
                      children: [
                        address(userID),
                        Container(
                            padding: EdgeInsets.only(
                                top: 10,
                                bottom:
                                    MediaQuery.of(context).size.height / 4.5),
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0xFF383CA0),
                                      spreadRadius: 1),
                                ]),
                            child: productHorizontalListTile(context, element)),
                        Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0xFF383CA0), spreadRadius: 1),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(() => Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        paymentController
                                            .selectPaymentMethod(context);
                                      },
                                      child: Column(
                                        children: [
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Phương thức thanh toán",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text("Thay đổi")
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                  paymentController
                                                      .selectedPaymentMethod
                                                      .value
                                                      .icon,
                                                ),
                                                fit: BoxFit.contain,
                                                height: 60,
                                              ),
                                              const VerticalDivider(),
                                              Text(paymentController
                                                  .selectedPaymentMethod
                                                  .value
                                                  .ten),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                    Text(
                                      "Tổng tiền: ${priceFormat(int.parse(price))}",
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                          ),
                        )
                      ],
                    )
                  : Container();
            }).toList()),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 5),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
                onPressed: () async {
                  final controller = Get.put(ProductSampleController());
                  if (orderController.checkAddressUser(userID) &&
                      controller.listModel
                              .firstWhere(
                                  (element) => element.MaSanPham == productID)
                              .soLuong >=
                          quantity) {
                    if (paymentController.selectedPaymentMethod.value.ten ==
                        'VNPay') {
                      await vnPayController.getUrlPayment(int.parse(price));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VnPayBuyNow(
                                  url: vnPayController.urlVNPay.value,price:  price,productID:  productID,quantity:  quantity,color:  color,config:  config)));
                    }
                    if (paymentController.selectedPaymentMethod.value.ten ==
                        'ZaloPay') {
                      final url = Uri.parse(zalo.createOrder(int.parse(price)));
                      final response = await http.get(url);
                      if (response.statusCode == 200) {
                        Map<String, dynamic> data = jsonDecode(response.body);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ZaloBuyNowScreen(
                                  url: data['orderurl'],price:  price,productID:  productID,quantity:  quantity,color:  color,config:  config)));
                      }
                    } if(paymentController.selectedPaymentMethod.value.ten=='Thanh toán khi nhận hàng') {
                      orderController.processOrderBuyNow(userID,
                          int.parse(price), productID, quantity, color, config);
                    }
                  } else if (controller.listModel
                          .firstWhere(
                              (element) => element.MaSanPham == productID)
                          .soLuong <
                      quantity) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Column(
                            children: [
                              Text('Hết hàng !!!'),
                              Icon(
                                Icons.warning_amber,
                                size: 30,
                              )
                            ],
                          ),
                          content: const Text(
                              'Sản phẩm tạm hết hàng, vui lòng thử lại sau hoặc liên hệ chúng tôi để được hỗ trợ'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF383CA0)),
                              child: const Text(
                                'Close',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Column(
                            children: [
                              Text('Thiếu thông tin !!!'),
                              Icon(
                                Icons.warning_amber,
                                size: 30,
                              )
                            ],
                          ),
                          content: const Text(
                              'Tài khoản của bạn cần cung cấp thông tin số điện thoại và địa chỉ để mua hàng'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF383CA0)),
                              child: const Text(
                                'Close',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF383CA0)),
                child:const  Text(
                  'Đặt hàng',
                  style:  TextStyle(color: Colors.white, fontSize: 15),
                  textAlign: TextAlign.center,
                )),
          ),
        ));
  }
}
