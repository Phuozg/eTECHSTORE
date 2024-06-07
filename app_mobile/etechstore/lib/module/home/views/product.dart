import 'package:etechstore/module/home/controllers/product_controller.dart';
import 'package:etechstore/module/product_detail/view/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Product extends StatelessWidget {
  const Product({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductControllerr());

    return Obx(() {
      if(productController.discountProducts.isEmpty){
        return const Center(child: Text("Không có dữ liệu"),);
      }
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
          SizedBox(
            height: MediaQuery.of(context).size.height/3.5,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: productController.discountProducts.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_,index){
                final product = productController.discountProducts[index];
                return GestureDetector(
                            onTap: (){
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                          HinhAnh: product.HinhAnh,
                                          GiaTien: product.GiaTien,
                                          KhuyenMai: product.KhuyenMai,
                                          MaDanhMuc: product.MaDanhMuc,
                                          MoTa: product.MoTa,
                                          Ten: product.Ten,
                                          TrangThai: product.TrangThai,
                                          id: product.id,
                                          thumbnail: product.thumbnail,
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
                                          child: Image.network(product.thumbnail,fit: BoxFit.cover,)
                                        ),
                                        Builder(
                                          builder: (context){
                                            if(product.KhuyenMai!=0){
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
                                                        product.KhuyenMai.toString()+"%",
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
                                    
                                    Text(product.Ten,style: const TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                                    Builder(
                                          builder: (context){
                                            if(product.KhuyenMai!=0){
                                              return Column(
                                                children: [
                                                  Text(
                                                    priceFormat(product.GiaTien),
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration.lineThrough
                                                      ),
                                                    ),
                                                    Text(priceFormat(((product.GiaTien-(product.GiaTien*product.KhuyenMai/100))).round()),style: const TextStyle(color: Colors.red))
                                                ],
                                              );
                                            }
                                            return Text(priceFormat(product.GiaTien),style: const TextStyle(color: Colors.red));
                                          },
                                          )
                                  ],
                                ),
                              ),
                            ),
                );
              }
            ),
          ),
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  "Xu hướng mua sắm",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color(0xFF383CA0)),
                ),
                TextButton(onPressed: null, child: Text("Xem tất cả"))
              ],  
            ),
          SizedBox(
            height: MediaQuery.of(context).size.height/3.5,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: productController.popularProducts.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_,index){
                final product = productController.popularProducts[index];
                return GestureDetector(
                            onTap: (){
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                          HinhAnh: product.HinhAnh,
                                          GiaTien: product.GiaTien,
                                          KhuyenMai: product.KhuyenMai,
                                          MaDanhMuc: product.MaDanhMuc,
                                          MoTa: product.MoTa,
                                          Ten: product.Ten,
                                          TrangThai: product.TrangThai,
                                          id: product.id,
                                          thumbnail: product.thumbnail,
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
                                          child: Image.network(product.thumbnail,fit: BoxFit.cover,)
                                        ),
                                        Builder(
                                          builder: (context){
                                            if(product.KhuyenMai!=0){
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
                                                        product.KhuyenMai.toString()+"%",
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
                                    
                                    Text(product.Ten,style: const TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                                    Builder(
                                          builder: (context){
                                            if(product.KhuyenMai!=0){
                                              return Column(
                                                children: [
                                                  Text(
                                                    priceFormat(product.GiaTien),
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration.lineThrough
                                                      ),
                                                    ),
                                                    Text(priceFormat(((product.GiaTien-(product.GiaTien*product.KhuyenMai/100))).round()),style: const TextStyle(color: Colors.red))
                                                ],
                                              );
                                            }
                                            return Text(priceFormat(product.GiaTien),style: const TextStyle(color: Colors.red));
                                          },
                                          )
                                  ],
                                ),
                              ),
                            ),
                );
              }
            ),
          ),
        ],
      );
    });
  }
}
 String priceFormat(int price){
  final priceOutput = NumberFormat.currency(locale: 'vi_VN',symbol: 'đ');
  return priceOutput.format(price);
}