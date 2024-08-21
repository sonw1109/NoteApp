import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:note_app/providers/notes/image_provider.dart';
import 'package:note_app/providers/notes/link_provider.dart';

class AddIcon extends ConsumerWidget {
  // final Function(TextEditingController) onAddNewLine;

  // const AddIcon({super.key, required this.onAddNewLine});

  @override
  Widget build(BuildContext, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                // onAddNewLine(TextEditingController());
              },
              icon: Image.asset('assets/images/add_icon.png'),
            ),
            const Text(
              "Add a new line",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color(0xff98A2B3),
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                ref.read(noteProvider.notifier).showTextInputDialog(BuildContext);
              },
              icon: Image.asset('assets/images/add_icon.png'),
            ),
            const Text(
              "Add a link",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color(0xff98A2B3),
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                ref.read(imageProvider.notifier).getImageGallery();
              },
              icon: Image.asset('assets/images/add_icon.png'),
            ),
            const Text(
              "Add a featured photo",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color(0xff98A2B3),
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Image.asset('assets/images/add_icon.png'),
            ),
            const Text(
              "Add a new emoji",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color(0xff98A2B3),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
