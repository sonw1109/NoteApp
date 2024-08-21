import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:note_app/providers/firebase_auth_implementatiton/firebase_data_profile.dart';
import 'package:note_app/providers/shared_preferences/shared_preferences.dart';

import 'package:note_app/screens/chat_screen.dart';
import 'package:note_app/screens/login_screen.dart';

import 'package:note_app/screens/profile_screen.dart';

class Information extends ConsumerWidget {
  const Information({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarNotifier = ref.read(avatarProvider.notifier);
    avatarNotifier.loadImageFromFirebase();

    final displayImage = ref.watch(avatarProvider);

    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: displayImage != null
                        ? FileImage(displayImage)
                        : (avatarNotifier.imageUrl != null
                            ? NetworkImage(avatarNotifier.imageUrl!)
                            : const AssetImage('assets/images/avt.png')) as ImageProvider,
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Messages'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
            },
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
