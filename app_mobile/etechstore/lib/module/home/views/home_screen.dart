import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/view/cart_screen.dart';
import 'package:etechstore/module/chat_with_admin/view/chat_home_screen.dart';
import 'package:etechstore/module/home/views/category.dart';
import 'package:etechstore/module/home/views/product.dart';
import 'package:etechstore/module/home/views/search_bar.dart';
import 'package:etechstore/module/home/views/slider_show.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.blue
          ),
        ),
        title: searchBar(),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  const  CartScreen(),
                  ));
            }, 
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: Colors.blue,
            ),
            child: const Icon(Icons.shopping_cart,color: Colors.white,),
          ),
          ElevatedButton(
            onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatHomePageScreen(),
                    ));
            }, 
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: Colors.blue
            ),
            child: const Icon(Icons.message,color: Colors.white,)
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: ListView(
          shrinkWrap: true,
          children: [
            //Danh mục sản phẩm
            Padding(
              padding:  const EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: 
                SizedBox(
                  height: MediaQuery.of(context).size.height/15,
                  child: category()
                ),
            ),
            //Banner khuyến mãi
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 6,
              child: sliderShow()
            ),
            
            //Danh sách sản phẩm
            product()
          ],
        ),
      ),
    );
  }
}
String priceFormat(int price){
  final priceOutput = NumberFormat.currency(locale: 'vi_VN',symbol: 'đ');
  return priceOutput.format(price);
}