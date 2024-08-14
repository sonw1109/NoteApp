import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/providers/image_provider.dart';
import 'package:note_app/providers/shared_preferences/shared_preferences.dart';
import 'package:note_app/screens/login_screen.dart';
import 'package:note_app/widgets/change_avatar.dart';

class Information extends ConsumerWidget {
  const Information({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarGallery = ref.watch(avatarGalleryProvider);
    final avatarPhoto = ref.watch(avatarPhotoProvider);

    // Logic để quyết định cái nào hiển thị
    final displayImage = avatarGallery ?? avatarPhoto;

    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: displayImage != null
                            ? FileImage(displayImage)
                            : const AssetImage('assets/images/avt.png') as ImageProvider,
                      ),
                      Positioned(
                        bottom: -10,
                        left: 40,
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return const BottomSheetContent();
                              },
                            );
                          },
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Messages'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () async {
              await ref.read(sharePreferencesProvider.notifier).signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
