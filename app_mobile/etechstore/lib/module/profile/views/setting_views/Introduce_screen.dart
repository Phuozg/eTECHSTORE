import 'package:etechstore/utlis/constants/colors.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IntroduceScreen extends StatelessWidget {
  const IntroduceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        backgroundColor: const Color(0xFFF3F3F4),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF3F3F4),
          iconTheme: const IconThemeData(color: TColros.purple_line),
          centerTitle: true,
          title: const Text("Thiết lập tài khoản", style: TColros.black_18),
        ),
        body: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 150,
                        child: Image.asset(
                          ImageKey.logoEtechStore,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const Text(
                        "eTECHSTORE",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400, color: TColros.purple_line),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: const Text(
                    '''E-Techstore là cửa hàng trực tuyến của CERATIZIT Hard Material Solutions. CERATIZIT là một tập đoàn kỹ thuật cao chuyên về dụng cụ cắt và giải pháp vật liệu cứng''',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
                const Text("Ứng dụng E-Techstore cho phép bạn: "),
                const SizedBox(height: 10),
                const Text("   1. Mua sắm 24/7: Dễ dàng tìm kiếm và mua sắm sản phẩm bất kỳ lúc nào, ở bất kỳ đâu.  "),
                const SizedBox(height: 10),
                const Text(
                    "   2. Tùy chỉnh sản phẩm: Nếu bạn không tìm thấy sản phẩm mong muốn trong danh mục tiêu chuẩn, ứng dụng cung cấp công cụ tùy chỉnh sản phẩm để đáp ứng nhu cầu của bạn."),
                const SizedBox(height: 10),
                const Text("   3. Hỗ trợ khách hàng: Đội ngũ hỗ trợ khách hàng luôn sẵn sàng giải đáp mọi thắc mắc của bạn."),
                const SizedBox(height: 10),
                const Text("   4. Quản lý đơn hàng: Xem lịch sử giao dịch, hóa đơn, theo dõi lịch sử vận chuyển.")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
