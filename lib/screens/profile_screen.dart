import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:note_app/providers/firebase_auth_implementatiton/firebase_data_profile.dart';
import 'package:note_app/screens/home_page.dart';

import 'package:note_app/widgets/change_avatar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarNotifier = ref.read(avatarProvider.notifier);
    // Lấy userId từ Firebase Authentication
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      // Tải thông tin người dùng từ Firestore
      avatarNotifier.loadImageFromFirebase(userId);
    }

    final displayImage = ref.watch(avatarProvider);

    final firstName = avatarNotifier.firstName ?? "";
    final lastName = avatarNotifier.lastName ?? "";
    final age = avatarNotifier.age ?? "";

    final firstNameController = TextEditingController(text: firstName);
    final lastNameController = TextEditingController(text: lastName);
    final ageController = TextEditingController(text: age);

    // Gradient sử dụng cho AppBar và body
    const gradient = LinearGradient(
      colors: [Color(0xFF1A3A53), Color(0xFF263544)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    // Màu cho AppBar (lấy màu từ điểm đầu tiên của gradient)
    final appBarColor = gradient.colors.first;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: gradient,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 50),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: displayImage != null
                                ? FileImage(displayImage)
                                : (avatarNotifier.imageUrl != null
                                    ? NetworkImage(avatarNotifier.imageUrl!)
                                    : const AssetImage('assets/images/avt.png')) as ImageProvider,
                          ),
                          Positioned(
                            bottom: -10,
                            left: 75,
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
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 29, 44, 54),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 29, 44, 54).withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 4,
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: firstNameController,
                            decoration: const InputDecoration(
                              hintText: "First Name",
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Divider(
                            thickness: BorderSide.strokeAlignCenter,
                          ),
                          TextFormField(
                            controller: lastNameController,
                            decoration: const InputDecoration(
                              hintText: "Last Name",
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Divider(
                            thickness: BorderSide.strokeAlignCenter,
                          ),
                          TextFormField(
                            controller: ageController,
                            decoration: const InputDecoration(
                              hintText: "Age",
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Divider(
                            thickness: BorderSide.strokeAlignCenter,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () async {
                                // Lấy thông tin người dùng từ các TextFormField
                                // String firstName = firstNameController.text;
                                // String lastName = lastNameController.text;
                                // String age = ageController.text;

                                if (userId != null) {
                                  await avatarNotifier.uploadToFirebase(
                                    userId,
                                    firstNameController.text,
                                    lastNameController.text,
                                    ageController.text,
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HomePage()),
                                  );
                                }
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => const HomePage()));
                              },
                              child: const Text(
                                "Approve",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
