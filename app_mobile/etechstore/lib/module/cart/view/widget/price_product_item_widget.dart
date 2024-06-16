import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriceProductItemWidget extends StatefulWidget {
  PriceProductItemWidget({super.key, required this.product});
  ProductModel product;
  @override
  State<PriceProductItemWidget> createState() => _PriceProductItemWidgetState();
}

class _PriceProductItemWidgetState extends State<PriceProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  widget.product.giaTien != null || widget.product.KhuyenMai != null
                      ? Text(
                          "${priceFormat((widget.product.giaTien - (widget.product.giaTien * widget.product.KhuyenMai / 100)).round())} ",
                          style: TextStyle(color: const Color(0xFFEB4335), fontSize: 16.sp),
                        )
                      : const Text("Loading..."),
                  SizedBox(
                    width: 5.w,
                  ),
                  widget.product.giaTien != null
                      ? Text(
                          priceFormat(widget.product.giaTien),
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            inherit: true,
                            color: Color(0xFFC4C4C4),
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      : const Text("Loading..."),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
