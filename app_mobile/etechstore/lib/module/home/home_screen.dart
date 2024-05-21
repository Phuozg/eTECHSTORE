import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/view/cart_screen.dart';
import 'package:etechstore/module/chat_with_admin/view/chat_home_screen.dart';
import 'package:etechstore/module/product_detail/view/controller_state_manage/detail_controller_state_manage.dart';
import 'package:etechstore/module/product_detail/view/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
     HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(DetailController());

  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration:    BoxDecoration(color: Colors.blue),
        ),
        title: searchBar(),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>    CartScreen(),
                  ));
            },
            style: ElevatedButton.styleFrom(shape:    CircleBorder(), backgroundColor: Colors.blue),
            child:    Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatHomePageScreen(),
                    ));
              },
              style: ElevatedButton.styleFrom(shape:    CircleBorder(), backgroundColor: Colors.blue),
              child:    Icon(
                Icons.message,
                color: Colors.white,
              )),
        ],
      ),
      body: Container(
        padding:    EdgeInsets.all(8),
        child: ListView(
          shrinkWrap: true,
          physics:    NeverScrollableScrollPhysics(),
          children: [
            //Banner khuyến mãi
            sliderShow(),

            //Danh mục sản phẩm
            category(),

            //Danh sách sản phẩm
            product()
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return Container(
      padding:    EdgeInsets.fromLTRB(0, 0, 0, 8),
      child:    TextField(
        decoration: InputDecoration(
            label: Text(
              "Tìm kiếm sản phẩm",
              style: TextStyle(color: Colors.white),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            )),
      ),
    );
  }

  Widget sliderShow() {
    final Stream<QuerySnapshot> discounts = FirebaseFirestore.instance.collection('KhuyenMaiBanner').snapshots();
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 6,
      child: StreamBuilder<QuerySnapshot>(
        stream: discounts,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return    Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return    Text("Loading");
          }

          return CarouselSlider(
            items: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  return Image.network(
                    data['HinhAnh'],
                    fit: BoxFit.fitHeight,
                  );
                })
                .toList()
                .cast(),
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              aspectRatio: 2.0,
              initialPage: 2,
            ),
          );
        },
      ),
    );
  }

  Widget category() {
    final Stream<QuerySnapshot> cateStream = FirebaseFirestore.instance.collection('DanhMucSanPham').snapshots();
    return Padding(
      padding:    EdgeInsets.fromLTRB(0, 15, 0, 15),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 15,
        child: StreamBuilder<QuerySnapshot>(
          stream: cateStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return    Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return    Text("Loading");
            }

            return ListView(
              scrollDirection: Axis.horizontal,
              children: snapshot.data!.docs
                  .map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return Container(
                      padding:    EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            data['TenDanhMuc'],
                            style:    TextStyle(color: Colors.black),
                          )),
                    );
                  })
                  .toList()
                  .cast(),
            );
          },
        ),
      ),
    );
  }

  Widget product() {
    final CollectionReference fetchProduct = FirebaseFirestore.instance.collection('SanPham');
    return Column(
      children: [
           Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Sản phẩm nổi bật",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(onPressed: null, child: Text("Xem tất cả"))
          ],
        ),
        SingleChildScrollView(
          child: StreamBuilder(
            stream: fetchProduct.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: GridView.builder(
                      gridDelegate:    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                        List<dynamic> HinhAnh = List<dynamic>.from(documentSnapshot['HinhAnh']);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                    HinhAnh: HinhAnh,
                                    GiaTien: documentSnapshot['GiaTien'],
                                    KhuyenMai: documentSnapshot['KhuyenMai'],
                                    MaDanhMuc: documentSnapshot['MaDanhMuc'],
                                    MoTa: documentSnapshot['MoTa'],
                                    SoLuong: documentSnapshot['SoLuong'],
                                    Ten: documentSnapshot['Ten'],
                                    TrangThai: documentSnapshot['TrangThai'],
                                    id: documentSnapshot['id'],
                                    thumbnail: documentSnapshot['thumbnail'],
                                  ),
                                ));
                          },
                          child: Card(
                            surfaceTintColor: Colors.white,
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                        height: MediaQuery.of(context).size.height / 7,
                                        child: Image.network(
                                          documentSnapshot['thumbnail'],
                                          fit: BoxFit.cover,
                                        )),
                                    Builder(
                                      builder: (context) {
                                        if (documentSnapshot['KhuyenMai'] != 0) {
                                          return Positioned(
                                              top: 0,
                                              left: 90,
                                              child: Container(
                                                decoration:    BoxDecoration(shape: BoxShape.rectangle, color: Colors.red),
                                                width: 100,
                                                height: 50,
                                                child: Padding(
                                                  padding:    EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "${documentSnapshot['KhuyenMai']}%",
                                                        style:    TextStyle(color: Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ));
                                        }
                                        return    Text("");
                                      },
                                    )
                                  ],
                                ),
                                Text(
                                  documentSnapshot['Ten'],
                                  style:    TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Builder(
                                  builder: (context) {
                                    if (documentSnapshot['KhuyenMai'] != 0) {
                                      return Column(
                                        children: [
                                          Text(
                                            priceFormat(documentSnapshot['GiaTien']),
                                            style:    TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough),
                                          ),
                                          Text(
                                              priceFormat(((documentSnapshot['GiaTien'] -
                                                      (documentSnapshot['GiaTien'] * documentSnapshot['KhuyenMai'] / 100)))
                                                  .round()),
                                              style:    TextStyle(color: Colors.red))
                                        ],
                                      );
                                    }
                                    return Text(priceFormat(documentSnapshot['GiaTien']), style:    TextStyle(color: Colors.red));
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                );
              } else if (snapshot.hasError) {
                return    Text('Something went wrong!');
              } else {
                return    Text('Something went wrong!');
              }
            },
          ),
        ),
      ],
    );
  }
}

String priceFormat(int price) {
  final priceOutput = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  return priceOutput.format(price);
}
