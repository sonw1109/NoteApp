import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_app/models/note.dart';

import 'package:note_app/providers/notes/image_provider.dart';
import 'package:note_app/providers/notes/link_provider.dart';

import 'package:note_app/providers/notes/savenote_provider.dart';
import 'package:note_app/widgets/add_icon.dart';

import 'package:note_app/widgets/bottom_navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpgradeScreen extends ConsumerWidget {
  const UpgradeScreen({super.key, required this.note});
  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final List<TextEditingController> textList = [];
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);

    void onSavePressed() {
      if (formKey.currentState!.validate()) {
        List<String> additionalContents = textList.map((controller) => controller.text).toList();
        final pathFromState = ref.read(imageProvider);
        final linkFromState = ref.read(noteProvider);

        final updatedNote = Note(
          idNote: note.idNote,
          title: titleController.text,
          content: contentController.text,
          additionalContents: additionalContents,
          link: linkFromState == null ? note.link : linkFromState.link,
          image: pathFromState == null ? note.image : pathFromState.path,
        );

        ref.read(saveProvider.notifier).updateDataFromDB(updatedNote);
        ref.read(imageProvider.notifier).resetImage();
        ref.read(noteProvider.notifier).resetNote();
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Back',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                ref.read(imageProvider.notifier).getImageGallery();
              },
              icon: Image.asset('assets/images/picture_icon.png'),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset('assets/images/file_icon.png'),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset('assets/images/font_icon.png'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(21, 24, 21, 0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.done,
                    maxLines: null,
                    minLines: 1,
                  ),
                ),
                TextFormField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    hintText: 'Content',
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.done,
                  maxLines: null,
                  minLines: 1,
                ),
                note.link != null
                    ? InkWell(
                        onTap: () {
                          ref.read(noteProvider.notifier).openAppBrowserView(note.link!);
                        },
// Delete Link
                        onLongPress: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 120,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      title: const Text('Delete Link'),
                                      onTap: () {
                                        ref.read(noteProvider.notifier).resetNote();
                                        note.link = null;
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.cancel),
                                      title: const Text('Cancle'),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          note.link!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : Container(),
                Container(
                  height: 24,
                ),
                note.image != null
                    ? InkWell(
                        onTap: () {
                          ref.read(imageProvider.notifier).getImageGallery();
                        },
// Delete Image
                        onLongPress: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 120,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      title: const Text('Delete Image'),
                                      onTap: () {
                                        ref.read(imageProvider.notifier).resetImage();
                                        note.image = null;
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.cancel),
                                      title: const Text('Cancle'),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Image.file(
                          File(note.image!),
                          height: 200,
                          width: double.infinity,
                        ),
                      )
                    : Container(),
                Container(
                  height: 24,
                ),
                AddIcon(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(onSave: onSavePressed),
    );
  }
}
