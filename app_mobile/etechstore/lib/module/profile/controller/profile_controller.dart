import 'dart:io';
import 'dart:math';
import 'package:etechstore/module/profile/model/local_storage_service.dart';
import 'package:etechstore/module/profile/model/profile_model.dart';
import 'package:etechstore/services/auth/auth_services.dart';
import 'package:etechstore/utlis/connection/network_manager.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:etechstore/utlis/helpers/popups/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final NetworkManager network = Get.put(NetworkManager());
  final LocalStorageService localStorageService = LocalStorageService();
  final AuthServices authServices = Get.put(AuthServices());

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController DressController = TextEditingController();
  TextEditingController textController = TextEditingController();

  RxString imageUrl = ''.obs;
  var isTextValid = false.obs;
  RxList<ProfileModel> profiles = <ProfileModel>[].obs;

  void clearText() {
    textController.clear();
    isTextValid.value = false;
  }

  void validateText(String text) {
    isTextValid.value = text.isNotEmpty;
  }

  //Get Profile
  Stream<List<ProfileModel>> fetchProfilesStream(String userId) {
    try {
      final isconnected = network.isConnectedToInternet.value;
      if (!isconnected) {
        fetchProfilesLocally();
        return Stream.value(profiles);
      } else {
        return firestore.collection('Users').where('uid', isEqualTo: userId).snapshots().map((snapshot) {
          final profileList = snapshot.docs.map((doc) {
            return ProfileModel.fromJson(doc.data());
          }).toList();
          localStorageService.saveProfiles(profileList);
          profiles.assignAll(profileList);
          return profileList;
        });
      }
    } catch (e) {
      return TLoaders.errorSnackBar(title: TTexts.thongBao, message: "Không có kết nối internet");
    }
  }

  void fetchProfilesLocally() async {
    List<ProfileModel> localProfiles = await localStorageService.getProfiles();
    profiles.assignAll(localProfiles);
  }

  void signOut() {
    final isconnected = network.isConnectedToInternet.value;
    if (!isconnected) {
      return TLoaders.errorSnackBar(title: TTexts.thongBao, message: "Không có kết nối internet");
    } else {
      authServices.signOut();
    }
  }

  //Edit Profile
  Future<void> editProfile(int choice) async {
    try {
      final isconnected = network.isConnectedToInternet.value;
      if (!isconnected) {
        return TLoaders.errorSnackBar(title: TTexts.thongBao, message: "Không có kết nối internet");
      } else {
        final FirebaseAuth auth = FirebaseAuth.instance;
        User? user = auth.currentUser;
        final uid = user!.uid;
        QuerySnapshot querySnapshot = await firestore.collection('Users').where('uid', isEqualTo: uid).get();

        if (querySnapshot.docs.isNotEmpty) {
          QueryDocumentSnapshot document = querySnapshot.docs.first;
          String documentId = document.id;

          switch (choice) {
            case 0:
              await firestore.collection('Users').doc(documentId).update({'HoTen': nameController.text});
              break;
            case 1:
              await firestore.collection('Users').doc(documentId).update({'SoDienThoai': int.parse(phoneNumberController.text)});
              break;
            case 2:
              await firestore.collection('Users').doc(documentId).update({'DiaChi': DressController.text});
              break;
          }

          TLoaders.successSnackBar(title: 'Thông báo', message: 'Sửa thành công.');
        } else {
          TLoaders.errorSnackBar(title: 'Thông báo', message: 'Sửa thất bại.');
        }
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Thông báo', message: 'Sửa thất bại.');
    }
  }

// Fetch Image from Gallery
  Future<void> fetchImageGallery() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    final uid = user!.uid;
    QuerySnapshot querySnapshot = await firestore.collection('Users').where('uid', isEqualTo: uid).get();

    if (querySnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot document = querySnapshot.docs.first;
      String documentId = document.id;
      ImagePicker imagePicker = ImagePicker();
      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

      if (file == null) return;
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      Reference referenceImageToUpload = referenceDirImages.child('$uniqueFileName.jpg');

      try {
        await referenceImageToUpload.putFile(File(file.path));
        String imageUrl = await referenceImageToUpload.getDownloadURL();
        await firestore.collection('Users').doc(documentId).update({'HinhDaiDien': imageUrl});
      } catch (error) {
        TLoaders.errorSnackBar(title: 'Thông báo', message: 'Sửa thất bại.');
      }
    }
  }

// Fetch Image from Camera
  Future<void> fetchImageCamera() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    final uid = user!.uid;
    QuerySnapshot querySnapshot = await firestore.collection('Users').where('uid', isEqualTo: uid).get();

    if (querySnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot document = querySnapshot.docs.first;
      String documentId = document.id;
      ImagePicker imagePicker = ImagePicker();
      XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

      if (file == null) return;
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      Reference referenceImageToUpload = referenceDirImages.child('$uniqueFileName.jpg');

      try {
        await referenceImageToUpload.putFile(File(file.path));
        String imageUrl = await referenceImageToUpload.getDownloadURL();
        await firestore.collection('Users').doc(documentId).update({'HinhDaiDien': imageUrl});
      } catch (error) {
        TLoaders.errorSnackBar(title: 'Thông báo', message: 'Sửa thất bại.');
      }
    }
  }
}
