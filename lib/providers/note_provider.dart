import 'package:note_app/models/note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<Note> notes = [];

final notesProvider = Provider((ref) {
  return notes;
});
