import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/providers/image_provider.dart';

class BottomSheetContent extends ConsumerWidget {
  const BottomSheetContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 120,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text("Camera"),
            onTap: () {
              ref.read(avatarPhotoProvider.notifier).takePhoto();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text("Gallery"),
            onTap: () {
              ref.read(avatarGalleryProvider.notifier).avatarGallery();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
