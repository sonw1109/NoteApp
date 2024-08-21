import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:note_app/providers/firebase_auth_implementatiton/firebase_data_profile.dart';

class BottomSheetContent extends ConsumerWidget {
  const BottomSheetContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarNotifier = ref.read(avatarProvider.notifier);
    ref.watch(avatarProvider.notifier.select((notifier) => notifier.isLoading));

    return SizedBox(
      height: 120,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text("Camera"),
            onTap: () async {
              await avatarNotifier.takePhoto();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text("Gallery"),
            onTap: () async {
              await avatarNotifier.pickFromGallery();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
