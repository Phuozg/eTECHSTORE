import 'package:etechstore/module/profile/controller/profile_controller.dart';
import 'package:etechstore/module/profile/model/profile_model.dart';
import 'package:etechstore/module/profile/views/edit_views/profile_edit_screen.dart';
import 'package:etechstore/module/profile/views/edit_views/widget/edit_profile_widget.dart';
import 'package:etechstore/module/profile/views/edit_views/widget/profile_edit_screen.dart';
import 'package:etechstore/module/profile/views/widget/list_help_profile.dart';
import 'package:etechstore/utlis/constants/colors.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/helpers/popups/loader.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../utlis/helpers/line/line_helper.dart';

class EditProfileScreen extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    // Gọi hàm fetchProfiles để tải dữ liệu
    profileController.fetchProfilesStream(user!.uid);
    return ScreenUtilInit(
        builder: (context, child) => Scaffold(
              appBar: AppBar(
                title: const Text("Sửa hồ sơ"),
                centerTitle: true,
              ),
              backgroundColor: const Color(0xFFF9F9F9),
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
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 31.w, vertical: 13.h),
                            color: const Color.fromARGB(62, 217, 217, 217),
                            width: double.infinity,
                            height: 110.h,
                            child: SizedBox(
                              width: 90.w,
                              child: Stack(children: [
                                profile.HinhDaiDien.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(70),
                                        child: FadeInImage.assetNetwork(
                                          imageErrorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                              ImageKey.iconUser,
                                              width: 100.w,
                                              height: 100.h,
                                            );
                                          },
                                          placeholder: ImageKey.iconProfile,
                                          width: 100.w,
                                          height: 100.h,
                                          image: profile.HinhDaiDien,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    : const SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: Center(
                                          child: Text('No profile picture'),
                                        ),
                                      ),
                                GestureDetector(
                                  onTap: () async {
                                    await showDialog<ImageSource>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Chọn ảnh'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                GestureDetector(
                                                  child: const Text('Chụp ảnh'),
                                                  onTap: () async {
                                                    Navigator.of(context).pop(ImageSource.camera);
                                                    await profileController.fetchImageCamera();
                                                  },
                                                ),
                                                const Padding(padding: EdgeInsets.all(8.0)),
                                                GestureDetector(
                                                  child: const Text('Chọn từ thư viện'),
                                                  onTap: () async {
                                                    Navigator.of(context).pop(ImageSource.gallery);
                                                    await profileController.fetchImageGallery();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.r),
                                        color: const Color.fromARGB(190, 211, 210, 210),
                                      ),
                                      width: 25.w,
                                      height: 25.h,
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(EditScreen(
                                title: "Sửa tên",
                                text: profile.HoTen,
                                func: () {
                                  profileController.editProfile(0);
                                },
                                controller: profileController.nameController,
                              ));
                            },
                            child: EditProfile(title: "Tên", text: profile.HoTen),
                          ),
                          Linehelper(color: const Color(0xFFD9D9D9), height: .8.h),
                          GestureDetector(
                              onTap: () {
                                Get.to(EditScreen(
                                  title: "Sửa số điện thoại",
                                  text: profile.SoDienThoai != 0 ? "0${profile.SoDienThoai.toString()}" : ("Số điện thoại"),
                                  func: () {
                                    profileController.editProfile(1);
                                  },
                                  controller: profileController.phoneNumberController,
                                ));
                              },
                              child: EditProfile(
                                  title: "Điện thoại",
                                  text: profile.SoDienThoai != 0 ? "0${profile.SoDienThoai.toString()}" : ("Thêm số điện thoại"))),
                          Linehelper(color: const Color.fromARGB(94, 217, 217, 217), height: 9.h),
                          GestureDetector(
                              onTap: () {
                                TLoaders.errorSnackBar(title: 'Thông báo', message: 'Không thể thay đổi Email.');
                              },
                              child: EditProfile(title: "Email", text: profile.Email)),
                          Linehelper(color: const Color(0xFFD9D9D9), height: .8.h),
                          GestureDetector(
                              onTap: () {
                                Get.to(EditScreen(
                                  controller: profileController.DressController,
                                  title: "Sửa địa chỉ",
                                  text: profile.DiaChi == '' ? "Thêm địa chỉ" : profile.DiaChi,
                                  func: () {
                                    profileController.editProfile(2);
                                  },
                                ));
                              },
                              child: EditProfile(title: "Địa chỉ", text: profile.DiaChi == '' ? "Thêm địa chỉ" : profile.DiaChi)),
                        ]);
                      },
                    );
                  }
                },
              ),
            ));
  }
}
