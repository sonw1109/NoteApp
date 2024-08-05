import 'package:note_app/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._init();

  final String _notesTableName = "notes";
  final String _notesIdColumnName = "id";
  final String _notesContentColumnName = "content";
  final String _notesTitleColumnName = "title";
  final String _notesAdditionalContentsColumnName = "additionalContents";
  final String _notesTimeColumnName = "time";
  final String _notesLinkColumnName = "link";
  final String _notesImageColumnName = "image";

  DatabaseService._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "note_db.db");

    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_notesTableName (
        $_notesIdColumnName INTEGER PRIMARY KEY,
        $_notesTitleColumnName TEXT NOT NULL,
        $_notesContentColumnName TEXT NOT NULL,
        $_notesAdditionalContentsColumnName TEXT,
        $_notesTimeColumnName TEXT NOT NULL,
        $_notesLinkColumnName TEXT,
        $_notesImageColumnName TEXT
        )
        ''');
      },
    );
    return database;
  }

  Future<void> insertNote(Map<String, dynamic> note) async {
    final db = await database;
    await db.insert(
      _notesTableName,
      note,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> getNote() async {
    final db = await database;
    final data = await db.query(_notesTableName);
    print(data);
    if (data.isNotEmpty) {
      return data.map((noteMap) => Note.fromMap(noteMap)).toList();
    } else {
      return [];
    }
  }

  Future<void> updateNote(Map<String, dynamic> note) async {
    final db = await database;
    await db.update(
      _notesTableName,
      note,
      where: '$_notesIdColumnName = ?',
      whereArgs: [note[_notesIdColumnName]],
    );
  }

  Future<void> deleteNote(int idNote) async {
    final db = await database;
    await db.delete(
      _notesTableName,
      where: '$_notesIdColumnName = ?',
      whereArgs: [idNote],
    );
  }
}
