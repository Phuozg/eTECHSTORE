import 'package:etechstore/module/profile/controller/profile_controller.dart';
import 'package:etechstore/module/profile/model/profile_model.dart';
import 'package:etechstore/module/profile/views/edit_views/profile_edit_screen.dart';
import 'package:etechstore/module/profile/views/widget/list_help_profile.dart';
import 'package:etechstore/services/auth/auth_services.dart';
import 'package:etechstore/utlis/constants/colors.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());
  final AuthServices authServices = Get.put(AuthServices());
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    // Gọi hàm fetchProfiles để tải dữ liệu
    profileController.fetchProfilesStream(user!.uid);

    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Hồ sơ của tôi'),
          centerTitle: true,
        ),
        body: StreamBuilder<List<ProfileModel>>(
          stream: profileController.fetchProfilesStream(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No profiles found'));
            } else {
              final profiles = snapshot.data!;
              return ListView.builder(
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  final profile = profiles[index];
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 31, vertical: 13),
                      color: const Color.fromARGB(62, 217, 217, 217),
                      width: double.infinity,
                      height: 115.h,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: Image.network(
                              width: 100.w,
                              height: 100.h,
                              profile.HinhDaiDien,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(width: 22.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 19.h),
                              SizedBox(
                                width: 179.w,
                                child: Text(
                                  profile.HoTen,
                                  style: TColros.black_19_w600,
                                  overflow: TextOverflow.clip,
                                  softWrap: true,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "0${profile.SoDienThoai.toString()}",
                                style: TColros.black_15_w400,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(EditProfileScreen());
                      },
                      child: ListHelpProfile(
                        icon: const Image(image: AssetImage(ImageKey.iconProfile), fit: BoxFit.fill),
                        text: "Sửa hồ sơ",
                      ),
                    ),
                    ListHelpProfile(icon: const Image(image: AssetImage(ImageKey.iconHeart)), text: "Yêu thích"),
                    ListHelpProfile(icon: const Image(image: AssetImage(ImageKey.iconBoxCart)), text: "Đơn hàng"),
                    ListHelpProfile(icon: const Image(image: AssetImage(ImageKey.iconSetting)), text: "Cài đặt"),
                    ListHelpProfile(icon: const Image(image: AssetImage(ImageKey.iconHelp)), text: "Hỗ trợ"),
                    GestureDetector(
                        onTap: () {
                          authServices.signOut();
                        },
                        child: ListHelpProfile(icon: const Image(image: AssetImage(ImageKey.iconLogOut)), text: "Đăng xuất"))
                  ]);
                },
              );
            }
          },
        ),
      ),
    );
  }
}