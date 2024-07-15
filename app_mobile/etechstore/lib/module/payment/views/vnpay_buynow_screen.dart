import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/payment/controllers/order_controller.dart';
import 'package:etechstore/module/payment/views/result_screen.dart';
import 'package:etechstore/module/payment/views/success_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class VnPayBuyNow extends StatefulWidget {
  const VnPayBuyNow({super.key,
  required this.url,
      required this.productID,
      required this.quantity,
      required this.price,
      required this.color,
      required this.config});
      final String url;
  final String productID;
  final int quantity;
  final String price;
  final String color;
  final String config;
  @override
  State<VnPayBuyNow> createState() => _VNPAYScreenState();
}

class _VNPAYScreenState extends State<VnPayBuyNow> {
  late final WebViewController _controller;
  final orderController = Get.put(OrderController());
  @override
  void initState() {
    super.initState();

    const PlatformWebViewControllerCreationParams params =
        PlatformWebViewControllerCreationParams();

    WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            if (url.contains('vnp_ResponseCode')) {
              final params = Uri.parse(url).queryParameters;
              if (params['vnp_ResponseCode'] == '00') {
                orderController.processOrderBuyNow(FirebaseAuth.instance.currentUser!.uid, int.parse(widget.price), widget.productID, widget.quantity,widget.config,widget.color);
                            
                Get.off(()=>const SuccessScreen());
              } else {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ResultScreen(isSucces: false)));
              }
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Thanh toán đơn hàng"),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
