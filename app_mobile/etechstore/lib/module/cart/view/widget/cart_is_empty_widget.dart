import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:flutter/cupertino.dart';import 'package:flutter_screenutil/flutter_screenutil.dart';


class CartIsEmptyWdiget extends StatefulWidget {
  const CartIsEmptyWdiget({super.key});

  @override
  State<CartIsEmptyWdiget> createState() => _CartIsEmptyWdigetState();
}

class _CartIsEmptyWdigetState extends State<CartIsEmptyWdiget> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (context, child) => 
      Column(
                children: [
                  SizedBox(height: 180.h),
                  Image.asset(
                    ImageKey.cartEmpty,
                    width: 100.w,
                    height: 100.h,
                  ),
                  SizedBox(height: 20.h),
                  const Center(
                      child: Text(
                    "Chưa có sản phẩm nào",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                  )),
                  const SizedBox(height: 60),
                ],
              ),
    );
  }
}