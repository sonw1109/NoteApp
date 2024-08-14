import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/providers/database_service.dart';

class ImagePickerNotifier extends StateNotifier<File?> {
  ImagePickerNotifier() : super(null);

  final picker = ImagePicker();

  Future<void> getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      state = File(pickedFile.path);
      print(state);
    } else {
      state = null;
    }
  }

  void resetImage() {
    if (state != null) {
      state = null;
    }
  }
}

class AvatarNotifier extends StateNotifier<File?> {
  AvatarNotifier() : super(null);

  final picker = ImagePicker();

  Future<void> takePhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);

    if (pickedFile != null) {
      state = File(pickedFile.path);
      print(state);
    } else {
      state = null;
    }
  }
}

class AvatarGalleryNotifier extends StateNotifier<File?> {
  AvatarGalleryNotifier() : super(null);

  final picker = ImagePicker();

  Future<void> avatarGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      state = File(pickedFile.path);
      print(state);
    } else {
      state = null;
    }
  }
}

final imageProvider =
    StateNotifierProvider<ImagePickerNotifier, File?>((ref) => ImagePickerNotifier());
final avatarPhotoProvider = StateNotifierProvider<AvatarNotifier, File?>((ref) => AvatarNotifier());
final avatarGalleryProvider =
    StateNotifierProvider<AvatarGalleryNotifier, File?>((ref) => AvatarGalleryNotifier());
