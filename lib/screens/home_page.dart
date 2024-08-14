import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

import 'package:note_app/models/note.dart';
import 'package:note_app/providers/database_service.dart';

import 'package:note_app/providers/image_provider.dart';
import 'package:note_app/providers/savenote_provider.dart';

import 'package:note_app/screens/upgrade_screen.dart';
import 'package:note_app/widgets/information.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  Future<void> fetchData() async {
    try {
      print('Fetching data...');
      await ref.read(saveProvider.notifier).getDataFromTable();
      print('Data fetched successfully.');
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService.instance;
    final notes = ref.watch(saveProvider);

    // final notes = ref.watch(saveProvider)..sort((a, b) => a.idNote.compareTo(b.idNote));

    final avatarGallery = ref.watch(avatarGalleryProvider);
    final avatarPhoto = ref.watch(avatarPhotoProvider);

    // Logic để quyết định cái nào hiển thị
    final displayImage = avatarGallery ?? avatarPhoto;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(21, 0, 0, 0),
          child: Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Note.d",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Enjoy note taking with friends",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Builder(
                builder: (context) => Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer(); // Mở Drawer khi nhấn vào avatar
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: displayImage != null
                            ? FileImage(displayImage)
                            : const AssetImage('assets/images/avt.png') as ImageProvider,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: const Information(),
      body: FutureBuilder(
        future: _future,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(21, 24, 21, 0),
              child: MasonryGridView.builder(
                itemCount: notes.length + 1,
                gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                mainAxisSpacing: 20,
                crossAxisSpacing: 16,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      height: 171,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        border: Border.all(
                          color: const Color(0xffB9E6FE),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () async {
                              final result = await Navigator.pushNamed(context, '/1');
                              if (result != null && result is Map<String, dynamic>) {
                                final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
                                final String formattedDate = dateFormat.format(DateTime.now());
                                final newNote = Note(
                                  title: result['title'],
                                  content: result['content'],
                                  additionalContents: result['additionalContents'],
                                  link: result['link'],
                                  image: result['image'],
                                  time: formattedDate,
                                );
                                ref.read(saveProvider.notifier).saveNote(newNote);
                                await databaseService.insertNote(newNote.toMap());
                              }
                            },
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                          const Text("New Note"),
                        ],
                      ),
                    );
                  }
                  final note = notes[index - 1];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpgradeScreen(note: note),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        border: Border.all(
                          color: const Color(0xffE4E7EC),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Note'),
                                content: const Text('Are you sure you want to delete this note?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancle'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      ref.read(saveProvider.notifier).deleteDataFromDB(note.idNote);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                              ),
                              Text(note.content),
                              if (note.additionalContents != null)
                                ...note.additionalContents!.map((item) => Text(item)),
                              if (note.link != null)
                                Text(
                                  note.link.toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              Container(
                                height: 8,
                              ),
                              if (note.image != null) Image.file(File(note.image!)),
                              Container(
                                height: 8,
                              ),
                              Text(note.time),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Text(
                'No notes available',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
        },
      ),
    );
  }
}
