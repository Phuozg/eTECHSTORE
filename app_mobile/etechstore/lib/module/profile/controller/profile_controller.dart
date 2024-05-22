import 'dart:io';
import 'dart:math';
import 'package:etechstore/module/profile/model/profile_model.dart';
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

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController DressController = TextEditingController();
  TextEditingController textController = TextEditingController();
  RxString imageUrl = ''.obs;
  var isTextValid = false.obs; // Observable boolean
 
  void clearText() {
    textController.clear();
    isTextValid.value = false;
  }

  void validateText(String text) {
    isTextValid.value = text.isNotEmpty;
  }

  //Get Profile
  Stream<List<ProfileModel>> fetchProfilesStream(String userId) {
    return firestore.collection('Users').where('uid', isEqualTo: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProfileModel.fromJson(doc.data());
      }).toList();
    });
  }

  //Edit Profile
  Future<void> editProfile(int choice) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    final uid = user!.uid;
    // Query to find the document with the matching UID
    QuerySnapshot querySnapshot = await firestore.collection('Users').where('uid', isEqualTo: uid).get();

    // Check if we have documents with the given UID
    if (querySnapshot.docs.isNotEmpty) {
      // Assuming we want to update the first matching document
      QueryDocumentSnapshot document = querySnapshot.docs.first;

      // Get the document ID
      String documentId = document.id;

      // Update the specific field in the document
      switch (choice) {
        case 0:
          await firestore.collection('Users').doc(documentId).update({'HoTen': nameController.text});
          break;
        case 1:
          await firestore.collection('Users').doc(documentId).update({'SoDienThoai': phoneNumberController.text});
          break;
        case 2:
          await firestore.collection('Users').doc(documentId).update({'DiaChi': DressController.text});
          break;
      }

      isTextValid == true ? TLoaders.successSnackBar(title: 'Thông báo', message: 'Sửa thành công.') : null;
    } else {
      TLoaders.errorSnackBar(title: 'Thông báo', message: 'Sửa thất bại.');
    }
  }

  //
  Future<void> fetchImageGallery() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    final uid = user!.uid;
    // Query to find the document with the matching UID
    QuerySnapshot querySnapshot = await firestore.collection('Users').where('uid', isEqualTo: uid).get();

    // Check if we have documents with the given UID
    if (querySnapshot.docs.isNotEmpty) {
      // Assuming we want to update the first matching document
      QueryDocumentSnapshot document = querySnapshot.docs.first;

      // Get the document ID
      String documentId = document.id;
      ImagePicker imagePicker = ImagePicker();
      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
      print('${file?.path}');

      if (file == null) return;
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');

      Reference referenceImageToUpload = referenceDirImages.child('$uniqueFileName.jpg');

      try {
        await referenceImageToUpload.putFile(File(file.path));
        imageUrl.value = (await referenceImageToUpload.getDownloadURL());

        await firestore.collection('Users').doc(documentId).update({'HinhDaiDien': imageUrl.value});
      } catch (error) {
        TLoaders.errorSnackBar(title: 'Thông báo', message: 'Sửa thất bại.');
      }
      return;
    }
  }

  //
  Future<void> fetchImageCamera() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    final uid = user!.uid;
    // Query to find the document with the matching UID
    QuerySnapshot querySnapshot = await firestore.collection('Users').where('uid', isEqualTo: uid).get();

    // Check if we have documents with the given UID
    if (querySnapshot.docs.isNotEmpty) {
      // Assuming we want to update the first matching document
      QueryDocumentSnapshot document = querySnapshot.docs.first;

      // Get the document ID
      String documentId = document.id;
      ImagePicker imagePicker = ImagePicker();
      XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
      print('${file?.path}');

      if (file == null) return;
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');

      Reference referenceImageToUpload = referenceDirImages.child('$uniqueFileName.jpg');

      try {
        await referenceImageToUpload.putFile(File(file.path));
        imageUrl.value = (await referenceImageToUpload.getDownloadURL());

        await firestore.collection('Users').doc(documentId).update({'HinhDaiDien': imageUrl.value});
      } catch (error) {
        TLoaders.errorSnackBar(title: 'Thông báo', message: 'Sửa thất bại.');
      }
      return;
    }
  }
}
