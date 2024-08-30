import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AvatarNotifier extends StateNotifier<File?> {
  AvatarNotifier() : super(null);

  final picker = ImagePicker();
  bool isLoading = false;
  String? imageUrl;
  String? firstName;
  String? lastName;
  String? age;

  Future<void> takePhoto() async {
    XFile? pickedPhotoFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    print('${pickedPhotoFile?.path}');
    if (pickedPhotoFile != null) {
      state = File(pickedPhotoFile.path);
    }
  }

  Future<void> pickFromGallery() async {
    XFile? pickedGalleryFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    print('${pickedGalleryFile?.path}');

    if (pickedGalleryFile != null) {
      state = File(pickedGalleryFile.path);
    }
  }

  Future<void> uploadToFirebase(String uid, String firstName, String lastName, String age) async {
    try {
      isLoading = true;
      Reference sr = FirebaseStorage.instance
          .ref()
          .child('Profile_Images/${DateTime.now().millisecondsSinceEpoch}.png');
      await sr.putFile(state!).whenComplete(() => {});
      imageUrl = await sr.getDownloadURL();
      print('Uploaded Image URL: $imageUrl');

      // Lưu trữ URL vào SharedPreferences
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setString('avatar_url', imageUrl!);

      // Lưu thông tin người dùng vào Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'first_name': firstName,
        'last_name': lastName,
        'age': age,
        'avatar_url': imageUrl,
      }, SetOptions(merge: true));

      print('User data and image URL saved to Firestore.');
    } catch (e) {
      print('Error occurred $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> loadImageFromFirebase(String uid) async {
    // // Lấy lại URL từ SharedPreferences
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // imageUrl = prefs.getString('avatar_url');
    // if (imageUrl != null) {
    //   // Sử dụng URL để tải ảnh khi khởi động ứng dụng
    //   print('Loaded Image URL: $imageUrl');
    // }

    // Lấy lại thông tin người dùng từ Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      firstName = userDoc['first_name'];
      lastName = userDoc['last_name'];
      age = userDoc['age'];
      imageUrl = userDoc['avatar_url'];
      print('Loaded user data from Firestore: $firstName $lastName $age $imageUrl');
    }
  }
}

final avatarProvider = StateNotifierProvider<AvatarNotifier, File?>((ref) => AvatarNotifier());
