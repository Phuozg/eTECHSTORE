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
        title: const Text("eTechStore"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [

            //Thanh tìm kiếm
            searchBar(),

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
                  border: OutlineInputBorder(),
                  label: Text("Tìm kiếm sản phẩm"),
                  prefixIcon: Icon(Icons.search)
                ),
              ),
    );

  }

  Widget category(){
    final Stream<QuerySnapshot> cateStream =
      FirebaseFirestore.instance.collection('DanhMucSanPham').snapshots();
    return Column(
      children: [
        const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  "Danh mục sản phẩm",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
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
                        child: ElevatedButton(onPressed: (){}, child: Text(data['TenDanhMuc'])
                        ),
                      );
                    })
                    .toList()
                    .cast(),
              );
            },
          ),
        ),
      ],
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
                      return Card(
                        surfaceTintColor: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height/7,
                              child: Image.network(documentSnapshot['thumbnail'],fit: BoxFit.cover,)
                            ),
                            Text(documentSnapshot['Ten'],style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(priceFormat(documentSnapshot['GiaTien']),style: const TextStyle(color: Colors.red)),
                          ],
                        ),
                      );
                      //Text(documentSnapshot['Ten'] );
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