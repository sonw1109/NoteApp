import 'package:flutter/material.dart';
import 'package:note_app/providers/image_provider.dart';

import 'package:note_app/providers/link_provider.dart';
import 'package:note_app/widgets/add_icon.dart';

import 'package:note_app/widgets/bottom_navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContentScreen extends ConsumerStatefulWidget {
  const ContentScreen({super.key});

  @override
  ConsumerState<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends ConsumerState<ContentScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _textList = [];
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final controller = TextEditingController();

  // void addNewLine(TextEditingController value) {
  //   setState(() {
  //     _textList.add(value);
  //   });
  // }

  void onSavePressed() {
    if (_formKey.currentState!.validate()) {
      List<String> additionalContents = _textList.map((controller) => controller.text).toList();

      Navigator.pop(context, {
        'title': _titleController.text,
        'content': _contentController.text,
        'additionalContents': additionalContents,
        'link': ref.watch(noteProvider)?.link,
        'image': ref.watch(imageProvider)?.path,
      });
      // Reset providers if needed
      ref.read(noteProvider.notifier).resetNote();
      ref.read(imageProvider.notifier).resetImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final getNote = ref.watch(noteProvider);
    final imageFile = ref.watch(imageProvider);

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
              onPressed: () {},
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
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    controller: _titleController,
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
                  controller: _contentController,
                  decoration: const InputDecoration(
                    hintText: 'Content',
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.done,
                  maxLines: null,
                  minLines: 1,
                ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 24),
                //   child: Column(
                //     children: [
                //       ...List.generate(_textList.length, (index) {
                //         final controller = _textList[index];
                //         return Dismissible(
                //           background: Container(
                //             color: Colors.red,
                //           ),
                //           key: ValueKey(_textList[index]),
                //           onDismissed: (DismissDirection direction) {
                //             setState(() {
                //               _textList.removeAt(index);
                //             });
                //           },
                //           child: TextFormField(
                //             controller: controller,
                //             decoration: InputDecoration(
                //               hintText: 'New ${index + 1}',
                //               border: InputBorder.none,
                //             ),
                //             textInputAction: TextInputAction.done,
                //             maxLines: null,
                //             minLines: 1,
                //           ),
                //         );
                //       }),
                //     ],
                //   ),
                // ),
//
                getNote?.link != null
                    ? InkWell(
                        onTap: () {
                          ref.read(noteProvider.notifier).openAppBrowserView(getNote.link!);
                        },
                        child: Text(
                          getNote!.link!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : Container(),
                Container(
                  height: 24,
                ),
// Hiện ảnh
                imageFile != null
                    ? InkWell(
                        onTap: () {
                          ref.read(imageProvider.notifier).getImageGallery();
                        },
// Xóa ảnh
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
                          imageFile,
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
