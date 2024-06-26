import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriceProductItemWidget extends StatefulWidget {
  PriceProductItemWidget({super.key, required this.product, required this.pirce});
  ProductModel product;
  int pirce;

  @override
  State<PriceProductItemWidget> createState() => _PriceProductItemWidgetState();
}

class _PriceProductItemWidgetState extends State<PriceProductItemWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<CartModel> cartItems = [];
  Map<String, Map<String, int>> priceMap = {};

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('GioHang').where('maKhachHang', isEqualTo: _auth.currentUser!.uid).get();

    List<CartModel> items = querySnapshot.docs.map((doc) => CartModel.fromFirestore(doc)).toList();
    setState(() {
      cartItems = items;
    });
  }

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
                          "${priceFormat(widget.pirce)} ",
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
