import 'package:etechstore/utlis/helpers/line/line_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SuportScreen extends StatelessWidget {
  const SuportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> listSuport = [
      '[Lỗi] Cách xử lý khi hệ thống không thể xác minh tải khoản eTECHSTORE của tôi để đăng nhập? ',
      '[Lỗi] Tại sao hệ thống không thể xác minh được yêu cầu đăng nhập của tôi?',
      '[Tài khoản eTECHSTORE] Cách đăng nhập tài khoản khi Quên Mật khẩu',
      '[Lỗi] Tại sao tài khoản eTECHSTORE của tôi bị khóa/giới hạn?',
      '[Đơn hàng] Tại sao đơn hàng của tôi không cập nhật trạng thái/chưa nhập được hàng?',
      '[Đánh giá sản phẩm] Tôi có thể xóa/chỉnh sửa đánh giá sản phẩm của mình trên eTECHSTORE không?'
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trung tâm hỗ trợ"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10, bottom: 5),
            child: Text(
              "Câu hỏi thường gặp liên quan",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),
          Linehelper(color: const Color.fromARGB(94, 217, 217, 217), height: 5),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: listSuport.length,
              itemBuilder: (context, index) {
                final item = listSuport[index];
                return Container(
                  margin: const EdgeInsets.only(left: 10, top: 5),
                  padding: const EdgeInsets.all(2),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Text(
                          item,
                          overflow: TextOverflow.clip,
                          maxLines: 5,
                          softWrap: true,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Linehelper(color: const Color.fromARGB(94, 217, 217, 217), height: 1),
                    ],
                  ),
                );
              },
            ),
          ),
          Linehelper(color: const Color.fromARGB(94, 217, 217, 217), height: 5),
          const Padding(
            padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
            child: Text(
              "Bạn muốn thêm thông tin gì không?",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),
          Linehelper(color: const Color.fromARGB(94, 217, 217, 217), height: 1),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 13, top: 13),
            child: Row(
              children: [
                const Icon(Icons.headset_mic_outlined, color: Colors.redAccent),
                const SizedBox(width: 10),
                const Text("Gọi tổng đài eTECHSTORE"),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(width: .5, color: Colors.redAccent),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    "Miễn phí",
                    style: TextStyle(color: Colors.redAccent, fontSize: 8),
                  ),
                ),
              ],
            ),
          ),
          Linehelper(color: const Color.fromARGB(94, 217, 217, 217), height: 226),
        ],
      ),
    );
  }
}
