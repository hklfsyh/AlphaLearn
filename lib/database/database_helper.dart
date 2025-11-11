import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// =========================================================
// 1. DATA DEFINITION LANGUAGE (DDL) - SKEMA TABEL
// =========================================================

final String createCategoryTable = '''
CREATE TABLE Category(
  category_id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  is_categorized_level INTEGER NOT NULL, -- 0 (FALSE) atau 1 (TRUE)
  sequence_order INTEGER NOT NULL
)
''';

final String createGameModeTable = '''
CREATE TABLE GameMode(
  mode_id INTEGER PRIMARY KEY,
  mode_name TEXT NOT NULL
)
''';

final String createContentWordTable = '''
CREATE TABLE ContentWord(
  word_id INTEGER PRIMARY KEY,
  category_id INTEGER NOT NULL,
  word TEXT NOT NULL,
  image_asset TEXT NOT NULL,
  FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE CASCADE
)
''';

final String createUserProgressTable = '''
CREATE TABLE UserProgress(
  progress_id INTEGER PRIMARY KEY,
  category_id INTEGER UNIQUE NOT NULL, 
  current_score INTEGER NOT NULL,
  max_questions INTEGER NOT NULL,
  is_completed INTEGER NOT NULL, -- 0 (FALSE) atau 1 (TRUE)
  FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE CASCADE
)
''';

final String createActivityCompletionTable = '''
CREATE TABLE ActivityCompletion(
  completion_id INTEGER PRIMARY KEY,
  word_id INTEGER NOT NULL,
  mode_id INTEGER NOT NULL,
  is_completed INTEGER NOT NULL, -- 0 (FALSE) atau 1 (TRUE)
  FOREIGN KEY (word_id) REFERENCES ContentWord(word_id) ON DELETE CASCADE,
  FOREIGN KEY (mode_id) REFERENCES GameMode(mode_id) ON DELETE CASCADE
)
''';

// =========================================================
// 2. DATABASE HELPER CLASS
// =========================================================

class DatabaseHelper {
  // Pola Singleton
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "alpha_learn.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  // Mengaktifkan Foreign Keys (PENTING)
  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // Fungsi yang dipanggil saat database baru dibuat
  Future _onCreate(Database db, int version) async {
    // Jalankan semua skrip CREATE TABLE
    await db.execute(createCategoryTable);
    await db.execute(createGameModeTable);
    await db.execute(createContentWordTable);
    await db.execute(createUserProgressTable);
    await db.execute(createActivityCompletionTable);

    // TIDAK ADA PEMANGGILAN FUNGSI SEEDING DI SINI
  }

  // --- FUNGSI CRUD DASAR (Anda perlu mengisi ini nanti) ---

  // Contoh: Menyisipkan data ke tabel statis (akan dipanggil HANYA SEKALI dari luar)
  Future<int> insertData(String tableName, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Contoh: Mengambil semua kategori (akan digunakan di halaman Progres)
  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return await db.query('Category');
  }

  // Fungsi CRUD lainnya (UPDATE, DELETE) akan ditambahkan di sini.
}
