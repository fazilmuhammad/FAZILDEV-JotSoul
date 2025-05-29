import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:jotsoul/models/journal_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('journal.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Updated version
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE journal_entries (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        date TEXT NOT NULL,
        wordCount INTEGER NOT NULL
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE journal_entries ADD COLUMN wordCount INTEGER NOT NULL DEFAULT 0');
    }
  }

  Future<JournalEntry> create(JournalEntry entry) async {
    final db = await instance.database;
    await db.insert('journal_entries', entry.toMap());
    return entry;
  }

  Future<JournalEntry> read(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'journal_entries',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return JournalEntry.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<JournalEntry>> readAll() async {
    final db = await instance.database;
    final result = await db.query('journal_entries', orderBy: 'date DESC');
    return result.map((json) => JournalEntry.fromMap(json)).toList();
  }

  Future<int> update(JournalEntry entry) async {
    final db = await instance.database;
    return await db.update(
      'journal_entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await instance.database;
    return await db.delete(
      'journal_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}