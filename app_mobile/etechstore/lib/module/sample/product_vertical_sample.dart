import 'package:etechstore/module/home/models/product_model.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/product_detail/view/product_detail_screen.dart';
import 'package:flutter/material.dart';

Widget productVerticalSample(BuildContext context,List<ProductModel> products){
  return Flexible(
    child: GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8),
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (_,index){
        final product = products[index];
        return SizedBox(
          height: MediaQuery.of(context).size.height/3,
          child: GestureDetector(
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
                                                  "${product.KhuyenMai.toString()}%",
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
          ),
        );
      }
    )
  );
}