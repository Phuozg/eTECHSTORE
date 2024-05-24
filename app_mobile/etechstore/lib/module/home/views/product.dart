import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/product_detail/view/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget product(){
    final Query<Map<String, dynamic>> fetchDiscountProduct =
      FirebaseFirestore.instance.collection('SanPham').orderBy("KhuyenMai",descending: true).limit(4);
    final Query<Map<String, dynamic>> fetchNewestProduct =
      FirebaseFirestore.instance.collection('SanPham').orderBy("NgayNhap",descending: true).limit(4);
      
    return Column(
      children: [
        const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  "DEAL CỰC CĂNG",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.red),
                ),
                TextButton(onPressed: null, child: Text("Xem tất cả"))
              ],  
            ),
        StreamBuilder(
          stream: fetchDiscountProduct.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                height: MediaQuery.of(context).size.height/3.5,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length ,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                     List<dynamic> HinhAnh = List<dynamic>.from(documentSnapshot['HinhAnh']);
                    return GestureDetector(
                      onTap: (){
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
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width/2,
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
        const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  "Xu hướng mua sắm",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: null, child: Text("Xem tất cả"))
              ],  
            ),
        StreamBuilder(
          stream: fetchNewestProduct.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                height: MediaQuery.of(context).size.height/3.5,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length ,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                     List<dynamic> HinhAnh = List<dynamic>.from(documentSnapshot['HinhAnh']);
                    return GestureDetector(
                      onTap: (){
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
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width/2,
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
      ],
    );
  }
  String priceFormat(int price){
  final priceOutput = NumberFormat.currency(locale: 'vi_VN',symbol: 'đ');
  return priceOutput.format(price);
}