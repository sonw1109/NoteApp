import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:note_app/models/note.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteNotifier extends StateNotifier<Note?> {
  NoteNotifier() : super(null);

  // Mở link
  Future<void> openAppBrowserView(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView)) {
      throw Exception("Could not launch $url");
    }
  }

  // Nhập link
  Future<void> showTextInputDialog(BuildContext context) async {
    TextEditingController linkController = TextEditingController();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Link'),
            content: TextField(
              controller: linkController,
              decoration: const InputDecoration(hintText: "Type your link here"),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (linkController.text.isNotEmpty) {
                    if (state != null) {
                      state = state?.updateNote(link: linkController.text);
                    } else {
                      state = Note(
                        title: 'New Note',
                        content: 'New Content',
                        link: linkController.text,
                      );
                    }
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Submit'),
              ),
              TextButton(
                child: const Text('Open Link'),
                onPressed: () {
                  final url = linkController.text;
                  if (url.isNotEmpty) {
                    openAppBrowserView(url);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        });
  }

  void resetNote() {
    if (state != null) {
      state = null;
    }
  }
}

final noteProvider = StateNotifierProvider<NoteNotifier, Note?>((ref) => NoteNotifier());
