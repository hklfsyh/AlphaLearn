import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  // Method untuk initialize database - panggil ini di main() atau splash screen
  static Future<void> initialize() async {
    final instance = DatabaseHelper();
    await instance
        .database; // Ini akan trigger _initDatabase dan _onCreate jika database belum ada
    print('Database AlphaLearn initialized successfully');
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'alphalearn.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Category table
    await db.execute('''
      CREATE TABLE Category (
        category_id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        is_categorized_level BOOLEAN NOT NULL,
        sequence_order INTEGER NOT NULL
      )
    ''');

    // Create GameMode table
    await db.execute('''
      CREATE TABLE GameMode (
        mode_id INTEGER PRIMARY KEY,
        mode_name TEXT NOT NULL
      )
    ''');

    // Create ContentWord table
    await db.execute('''
      CREATE TABLE ContentWord (
        word_id INTEGER PRIMARY KEY,
        category_id INTEGER NOT NULL,
        word TEXT NOT NULL,
        image_asset TEXT,
        FOREIGN KEY (category_id) REFERENCES Category (category_id)
      )
    ''');

    // Create UserProgress table
    await db.execute('''
      CREATE TABLE UserProgress (
        progress_id INTEGER PRIMARY KEY,
        category_id INTEGER NOT NULL,
        current_score INTEGER NOT NULL DEFAULT 0,
        max_questions INTEGER NOT NULL,
        is_completed BOOLEAN NOT NULL DEFAULT 0,
        FOREIGN KEY (category_id) REFERENCES Category (category_id)
      )
    ''');

    // Create ActivityCompletion table
    await db.execute('''
      CREATE TABLE ActivityCompletion (
        completion_id INTEGER PRIMARY KEY,
        word_id INTEGER NOT NULL,
        mode_id INTEGER NOT NULL,
        is_completed BOOLEAN NOT NULL DEFAULT 0,
        FOREIGN KEY (word_id) REFERENCES ContentWord (word_id),
        FOREIGN KEY (mode_id) REFERENCES GameMode (mode_id)
      )
    ''');

    // Insert dummy data from JSON file
    await _insertDummyDataFromJson(db);
  }

  Future<void> _insertDummyDataFromJson(Database db) async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/dummy_data.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);

      // Insert Category data
      List<dynamic> categoryData = jsonData['category_data'] ?? [];
      for (var category in categoryData) {
        await db.insert('Category', {
          'category_id': category['category_id'],
          'name': category['name'],
          'is_categorized_level': category['is_categorized_level'] ? 1 : 0,
          'sequence_order': category['sequence_order'],
        });
      }

      // Insert GameMode data
      List<dynamic> gameModeData = jsonData['gamemode_data'] ?? [];
      for (var gameMode in gameModeData) {
        await db.insert('GameMode', {
          'mode_id': gameMode['mode_id'],
          'mode_name': gameMode['mode_name'],
        });
      }

      // Insert ContentWord data
      List<dynamic> contentWordData = jsonData['contentword_data'] ?? [];
      for (var contentWord in contentWordData) {
        await db.insert('ContentWord', {
          'word_id': contentWord['word_id'],
          'category_id': contentWord['category_id'],
          'word': contentWord['word'],
          'image_asset':
              contentWord['image_asset'], // null values akan dihandle otomatis
        });
      }

      // Insert UserProgress data
      List<dynamic> userProgressData = jsonData['userprogress_data'] ?? [];
      for (var userProgress in userProgressData) {
        await db.insert('UserProgress', {
          'progress_id': userProgress['progress_id'],
          'category_id': userProgress['category_id'],
          'current_score': userProgress['current_score'],
          'max_questions': userProgress['max_questions'],
          'is_completed': userProgress['is_completed'] ? 1 : 0,
        });
      }

      // ActivityCompletion - KOSONG, biarkan ter-create saat user bermain
      // Tidak ada insert dummy data untuk ActivityCompletion karena ini adalah history completion

      print('Dummy data loaded successfully from JSON');
    } catch (e) {
      print('Error loading dummy data from JSON: $e');
      // Fallback: insert minimal data if JSON fails
      await _insertFallbackData(db);
    }
  }

  Future<void> _insertFallbackData(Database db) async {
    // Fallback data jika JSON gagal load
    await db.insert('Category', {
      'category_id': 1,
      'name': 'Buah',
      'is_categorized_level': 1,
      'sequence_order': 1,
    });

    await db.insert('GameMode', {
      'mode_id': 1,
      'mode_name': 'Tebak Huruf',
    });
  }

  // Method untuk mengambil semua kategori
  Future<List<Map<String, dynamic>>> getAllCategories() async {
    final db = await database;
    return await db.query('Category', orderBy: 'sequence_order ASC');
  }

  // Method untuk mengambil kategori berdasarkan level
  Future<List<Map<String, dynamic>>> getCategoriesByLevel(
      bool isCategorizedLevel) async {
    final db = await database;
    return await db.query(
      'Category',
      where: 'is_categorized_level = ?',
      whereArgs: [isCategorizedLevel ? 1 : 0],
      orderBy: 'sequence_order ASC',
    );
  }

  // Method untuk mengambil kategori berdasarkan ID
  Future<Map<String, dynamic>?> getCategoryById(int categoryId) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'Category',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Method untuk mengambil semua game modes
  Future<List<Map<String, dynamic>>> getAllGameModes() async {
    final db = await database;
    return await db.query('GameMode', orderBy: 'mode_id ASC');
  }

  // Method untuk mengambil game mode berdasarkan ID
  Future<Map<String, dynamic>?> getGameModeById(int modeId) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'GameMode',
      where: 'mode_id = ?',
      whereArgs: [modeId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Method untuk mengambil semua content words
  Future<List<Map<String, dynamic>>> getAllContentWords() async {
    final db = await database;
    return await db.query('ContentWord', orderBy: 'word_id ASC');
  }

  // Method untuk mengambil content words berdasarkan kategori
  Future<List<Map<String, dynamic>>> getContentWordsByCategory(
      int categoryId) async {
    final db = await database;
    return await db.query(
      'ContentWord',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'word_id ASC',
    );
  }

  // Method untuk mengambil content word berdasarkan ID
  Future<Map<String, dynamic>?> getContentWordById(int wordId) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'ContentWord',
      where: 'word_id = ?',
      whereArgs: [wordId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Method untuk mengupdate image_asset dari content word
  Future<int> updateContentWordImageAsset(int wordId, String imageAsset) async {
    final db = await database;
    return await db.update(
      'ContentWord',
      {'image_asset': imageAsset},
      where: 'word_id = ?',
      whereArgs: [wordId],
    );
  }

  // Method untuk mengambil semua user progress
  Future<List<Map<String, dynamic>>> getAllUserProgress() async {
    final db = await database;
    return await db.query('UserProgress', orderBy: 'progress_id ASC');
  }

  // Method untuk mengambil user progress berdasarkan kategori
  Future<Map<String, dynamic>?> getUserProgressByCategory(
      int categoryId) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'UserProgress',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Method untuk mengupdate progress user
  Future<int> updateUserProgress({
    required int categoryId,
    required int currentScore,
    required bool isCompleted,
  }) async {
    final db = await database;
    return await db.update(
      'UserProgress',
      {
        'current_score': currentScore,
        'is_completed': isCompleted ? 1 : 0,
      },
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
  }

  // Method untuk cek apakah kategori terkunci berdasarkan sequential logic
  Future<bool> isCategoryLocked(int categoryId) async {
    final db = await database;

    // Kategori Alfabet (id: 6) selalu terbuka
    if (categoryId == 6) return false;

    // Untuk kategori lain, cek apakah Alfabet sudah selesai
    List<Map<String, dynamic>> alphabetProgress = await db.query(
      'UserProgress',
      where: 'category_id = ? AND is_completed = ?',
      whereArgs: [6, 1],
    );

    // Jika alfabet belum selesai, semua kategori terkunci
    if (alphabetProgress.isEmpty) return true;

    // Jika alfabet selesai, cek sequential order
    List<Map<String, dynamic>> categoryProgress = await db.query(
      'UserProgress',
      where: 'category_id < ? AND is_completed = ?',
      whereArgs: [categoryId, 0],
    );

    // Jika ada kategori sebelumnya yang belum selesai, maka terkunci
    return categoryProgress.isNotEmpty;
  }

  // Method untuk reset semua progress (untuk testing/debugging)
  Future<void> resetAllProgress() async {
    final db = await database;
    await db.update('UserProgress', {
      'current_score': 0,
      'is_completed': 0,
    });
  }

  // ========== ActivityCompletion Methods ==========

  // Method untuk create activity completion saat user selesai bermain
  Future<int> insertActivityCompletion({
    required int wordId,
    required int modeId,
    required bool isCompleted,
  }) async {
    final db = await database;
    return await db.insert('ActivityCompletion', {
      'word_id': wordId,
      'mode_id': modeId,
      'is_completed': isCompleted ? 1 : 0,
    });
  }

  // Method untuk cek apakah word sudah diselesaikan di mode tertentu
  Future<bool> isWordCompletedInMode(int wordId, int modeId) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'ActivityCompletion',
      where: 'word_id = ? AND mode_id = ? AND is_completed = ?',
      whereArgs: [wordId, modeId, 1],
    );
    return result.isNotEmpty;
  }

  // Method untuk mengambil semua activity completion
  Future<List<Map<String, dynamic>>> getAllActivityCompletions() async {
    final db = await database;
    return await db.query('ActivityCompletion', orderBy: 'completion_id ASC');
  }

  // Method untuk mengambil completion berdasarkan kategori dan mode
  Future<List<Map<String, dynamic>>> getCompletionsByCategoryAndMode({
    required int categoryId,
    required int modeId,
  }) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT ac.*, cw.word, cw.category_id 
      FROM ActivityCompletion ac
      JOIN ContentWord cw ON ac.word_id = cw.word_id
      WHERE cw.category_id = ? AND ac.mode_id = ?
      ORDER BY ac.completion_id ASC
    ''', [categoryId, modeId]);
  }

  // Method untuk menghitung berapa kata yang sudah diselesaikan dalam kategori tertentu
  Future<int> getCompletedWordsCount(int categoryId, int modeId) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT COUNT(*) as count
      FROM ActivityCompletion ac
      JOIN ContentWord cw ON ac.word_id = cw.word_id
      WHERE cw.category_id = ? AND ac.mode_id = ? AND ac.is_completed = 1
    ''', [categoryId, modeId]);

    return result.first['count'] as int;
  }

  // Method untuk update completion status
  Future<int> updateActivityCompletion({
    required int wordId,
    required int modeId,
    required bool isCompleted,
  }) async {
    final db = await database;

    // Cek apakah record sudah ada
    List<Map<String, dynamic>> existing = await db.query(
      'ActivityCompletion',
      where: 'word_id = ? AND mode_id = ?',
      whereArgs: [wordId, modeId],
    );

    if (existing.isNotEmpty) {
      // Update existing record
      return await db.update(
        'ActivityCompletion',
        {'is_completed': isCompleted ? 1 : 0},
        where: 'word_id = ? AND mode_id = ?',
        whereArgs: [wordId, modeId],
      );
    } else {
      // Insert new record
      return await insertActivityCompletion(
        wordId: wordId,
        modeId: modeId,
        isCompleted: isCompleted,
      );
    }
  }

  // Method untuk reset completion dalam kategori tertentu (untuk testing)
  Future<void> resetCategoryCompletion(int categoryId, int modeId) async {
    final db = await database;
    await db.rawDelete('''
      DELETE FROM ActivityCompletion 
      WHERE word_id IN (
        SELECT word_id FROM ContentWord WHERE category_id = ?
      ) AND mode_id = ?
    ''', [categoryId, modeId]);
  }
}
