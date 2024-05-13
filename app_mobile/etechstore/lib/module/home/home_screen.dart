import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
            onPressed: (){}, 
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: Colors.blue
            ),
            child: const Icon(Icons.shopping_cart,color: Colors.white,),
          ),
          ElevatedButton(
            onPressed: (){}, 
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
          physics: const NeverScrollableScrollPhysics(),
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

  Widget searchBar(){
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: const TextField(
                decoration: InputDecoration(
                  label: Text("Tìm kiếm sản phẩm",style: TextStyle(
                    color: Colors.white
                  ),),
                  prefixIcon: Icon(Icons.search,color: Colors.white,)
                ),
              ),
    );

  }

  Widget sliderShow(){
    final Stream<QuerySnapshot> discounts =
      FirebaseFirestore.instance.collection('KhuyenMaiBanner').snapshots();
    return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 6,
          child: StreamBuilder<QuerySnapshot>(
            stream: discounts,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
          
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }
          
              return CarouselSlider(
                items: snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Image.network(data['HinhAnh'],fit: BoxFit.fitHeight,);
                    })
                    .toList()
                    .cast(), 
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  aspectRatio: 2.0,
                  initialPage: 2,
                ),);
            },
          ),
        );
  }

  Widget category(){
    final Stream<QuerySnapshot> cateStream =
      FirebaseFirestore.instance.collection('DanhMucSanPham').snapshots();
    return Padding(
      padding:  const EdgeInsets.fromLTRB(0, 15, 0, 15),
      child: 
        SizedBox(
          height: MediaQuery.of(context).size.height/15,
          child: StreamBuilder<QuerySnapshot>(
            stream: cateStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
          
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }
          
              return ListView(
                scrollDirection: Axis.horizontal,
                children: snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: ElevatedButton(
                          onPressed: (){}, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            data['TenDanhMuc'],
                            style: const TextStyle(color: Colors.black),
                          )
                        ),
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

   Widget product(){
    final CollectionReference fetchProduct =
      FirebaseFirestore.instance.collection('SanPham');
    return Column(
      children: [
        const Row(
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
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8
                    ),
                    itemCount: snapshot.data!.docs.length ,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: (){},
                        child: Card(
                          surfaceTintColor: Colors.white,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height/7,
                                    child: Image.network(documentSnapshot['thumbnail'],fit: BoxFit.cover,)
                                  ),
                                  Builder(
                                    builder: (context){
                                      if(documentSnapshot['KhuyenMai']!=0){
                                        return Positioned(
                                          top: 0,
                                          left: 90,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Colors.red
                                            ),
                                            width: 100,
                                            height: 50,
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(5,0,0,0),
                                              child: Row(
                                                children: [Text(
                                                  documentSnapshot['KhuyenMai'].toString()+"%",
                                                  style: const TextStyle(
                                                    color: Colors.white
                                                  ),
                                                )],
                                              ),
                                            ),
                                          ));
                                      }
                                      return const Text("");
                                    },
                                    )
                                  
                                ],
                              ),
                              
                              Text(documentSnapshot['Ten'],style: const TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                              Builder(
                                    builder: (context){
                                      if(documentSnapshot['KhuyenMai']!=0){
                                        return Column(
                                          children: [
                                            Text(
                                              priceFormat(documentSnapshot['GiaTien']),
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                decoration: TextDecoration.lineThrough
                                                ),
                                              ),
                                              Text(priceFormat(((documentSnapshot['GiaTien']-(documentSnapshot['GiaTien']*documentSnapshot['KhuyenMai']/100))).round()),style: const TextStyle(color: Colors.red))
                                          ],
                                        );
                                      }
                                      return Text(priceFormat(documentSnapshot['GiaTien']),style: const TextStyle(color: Colors.red));
                                    },
                                    )
                            ],
                          ),
                        ),
                      );
                    }
                    ),
                );
              } else if (snapshot.hasError) {
                return const Text('Something went wrong!');
              } else {
                return const Text('Something went wrong!');
              }
            },
          ),
        ),
      ],
    );
  }
}

String priceFormat(int price){
  final priceOutput = NumberFormat.currency(locale: 'vi_VN',symbol: 'đ');
  return priceOutput.format(price);
}