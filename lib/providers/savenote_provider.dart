import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/providers/database_service.dart';

class SavenoteNotifier extends StateNotifier<List<Note>> {
  SavenoteNotifier() : super([]);

  final DatabaseService _databaseService = DatabaseService.instance;

  void saveNote(Note note) {
    state = [...state, note];
    // _databaseService.insertNote(note.toMap());
  }

  void deleteDataFromDB(int idNote) {
    state = state.where((note) => note.idNote != idNote).toList();
    _databaseService.deleteNote(idNote);
  }

  void updateDataFromDB(Note updateNote) {
    state = state
        .map((note) => note.idNote == updateNote.idNote ? updateNote : note)
        .toList();
    _databaseService.updateNote(updateNote.toMap());
  }

  Future<void> getDataFromTable() async {
    final List<Note> result = await _databaseService.getNote();
    state = result;
  }
}

final saveProvider = StateNotifierProvider<SavenoteNotifier, List<Note>>((ref) {
  return SavenoteNotifier();
});
