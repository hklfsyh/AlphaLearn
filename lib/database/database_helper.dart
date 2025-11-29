import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// DatabaseHelper untuk AlphaLearn App
///
/// Struktur Database untuk Progressive Unlocking System:
/// - Semua level dikunci saat install pertama kali
/// - Hanya Alfabet Level A yang terbuka
/// - Level unlock secara berurutan setelah menyelesaikan level sebelumnya
///
/// Flow Unlock:
/// 1. Alfabet A → B → C → D → E (Mode Alfabet)
/// 2. Selesai Alfabet E → Tebak Huruf Buah Level 1
/// 3. Buah 1 → 2 → 3 → 4 → 5
/// 4. Selesai Buah 5 → Binatang 1 → 2 → 3 → 4 → 5
/// 5. Selesai Binatang 5 → Tubuh 1 → 2 → 3 → 4 → 5
/// 6. Selesai Tubuh 5 → Benda 1 → 2 → 3 → 4 → 5
/// 7. Selesai Benda 5 → Keluarga 1 → 2 → 3 → 4 → 5
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  /// Initialize database - panggil di main() atau splash screen
  static Future<void> initialize() async {
    final instance = DatabaseHelper();
    await instance.database;
    print('✅ Database AlphaLearn initialized successfully');
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'alphalearn_v2.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Reset database - hapus dan buat ulang dari awal
  /// Gunakan untuk testing atau reset progress user
  Future<void> resetDatabase() async {
    try {
      if (_database != null) {
        await _database!.close();
        _database = null;
      }

      String path = join(await getDatabasesPath(), 'alphalearn_v2.db');
      await databaseFactory.deleteDatabase(path);
      print('🗑️ Database deleted');

      await database;
      print('✅ Database recreated with fresh data');
    } catch (e) {
      print('❌ Error resetting database: $e');
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // ========== TABLE: categories ==========
    // Menyimpan kategori (Buah, Binatang, Tubuh, Benda, Keluarga, Alfabet)
    await db.execute('''
      CREATE TABLE categories (
        category_id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        sequence_order INTEGER NOT NULL,
        description TEXT,
        icon_path TEXT
      )
    ''');

    // ========== TABLE: game_modes ==========
    // Menyimpan mode game (Tebak Huruf, Alfabet)
    await db.execute('''
      CREATE TABLE game_modes (
        mode_id INTEGER PRIMARY KEY,
        mode_name TEXT NOT NULL,
        description TEXT
      )
    ''');

    // ========== TABLE: levels ==========
    // Menyimpan semua level dari semua kategori dan mode
    // global_sequence: urutan global untuk progressive unlock
    await db.execute('''
      CREATE TABLE levels (
        level_id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL,
        mode_id INTEGER NOT NULL,
        level_number INTEGER NOT NULL,
        global_sequence INTEGER NOT NULL UNIQUE,
        word_id INTEGER,
        FOREIGN KEY (category_id) REFERENCES categories (category_id),
        FOREIGN KEY (mode_id) REFERENCES game_modes (mode_id),
        FOREIGN KEY (word_id) REFERENCES words (word_id)
      )
    ''');

    // ========== TABLE: words ==========
    // Menyimpan data kata/huruf beserta asset gambar
    await db.execute('''
      CREATE TABLE words (
        word_id INTEGER PRIMARY KEY,
        category_id INTEGER NOT NULL,
        word TEXT NOT NULL,
        image_asset TEXT,
        description TEXT,
        FOREIGN KEY (category_id) REFERENCES categories (category_id)
      )
    ''');

    // ========== TABLE: user_progress ==========
    // Tracking progress user per level
    // is_unlocked: level ini sudah terbuka atau masih terkunci
    // is_completed: level ini sudah diselesaikan atau belum
    // score: skor yang didapat (0-100 atau sesuai kebutuhan)
    // stars: bintang yang didapat (1-3)
    await db.execute('''
      CREATE TABLE user_progress (
        progress_id INTEGER PRIMARY KEY AUTOINCREMENT,
        level_id INTEGER NOT NULL UNIQUE,
        is_unlocked INTEGER NOT NULL DEFAULT 0,
        is_completed INTEGER NOT NULL DEFAULT 0,
        score INTEGER DEFAULT 0,
        stars INTEGER DEFAULT 0,
        completed_at TEXT,
        FOREIGN KEY (level_id) REFERENCES levels (level_id)
      )
    ''');

    // Insert initial data
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    // ========== INSERT CATEGORIES ==========
    await db.insert('categories', {
      'category_id': 1,
      'name': 'Buah',
      'sequence_order': 1,
      'description': 'Kategori untuk belajar nama-nama buah',
      'icon_path': 'assets/images/buah.png',
    });

    await db.insert('categories', {
      'category_id': 2,
      'name': 'Binatang',
      'sequence_order': 2,
      'description': 'Kategori untuk belajar nama-nama binatang',
      'icon_path': 'assets/images/monyet.png',
    });

    await db.insert('categories', {
      'category_id': 3,
      'name': 'Tubuh',
      'sequence_order': 3,
      'description': 'Kategori untuk belajar nama-nama bagian tubuh',
      'icon_path': 'assets/images/tubuh.png',
    });

    await db.insert('categories', {
      'category_id': 4,
      'name': 'Benda',
      'sequence_order': 4,
      'description': 'Kategori untuk belajar nama-nama benda',
      'icon_path': 'assets/images/furniture.png',
    });

    await db.insert('categories', {
      'category_id': 5,
      'name': 'Keluarga',
      'sequence_order': 5,
      'description': 'Kategori untuk belajar nama-nama anggota keluarga',
      'icon_path': 'assets/images/keluarga.png',
    });

    await db.insert('categories', {
      'category_id': 6,
      'name': 'Alfabet',
      'sequence_order': 0,
      'description': 'Belajar alfabet A sampai E secara berurutan',
      'icon_path': 'assets/images/alfabeth.png',
    });

    // ========== INSERT GAME MODES ==========
    await db.insert('game_modes', {
      'mode_id': 1,
      'mode_name': 'Tebak Huruf',
      'description': 'Game menebak huruf berdasarkan gambar',
    });

    await db.insert('game_modes', {
      'mode_id': 2,
      'mode_name': 'Alfabet',
      'description': 'Game menyusun alfabet A-Z secara berurutan',
    });

    // ========== INSERT WORDS ==========
    // Kategori Buah (category_id: 1)
    final buahWords = [
      {'word_id': 101, 'word': 'APEL', 'asset': 'asset-apel.png'},
      {'word_id': 102, 'word': 'BELIMBING', 'asset': 'asset-belimbing.png'},
      {'word_id': 103, 'word': 'CHERRY', 'asset': 'asset-cherry.png'},
      {'word_id': 104, 'word': 'DURIAN', 'asset': 'asset-durian.png'},
      {'word_id': 105, 'word': 'ELDERBERRY', 'asset': 'asset-elderberry.png'},
    ];

    for (var word in buahWords) {
      await db.insert('words', {
        'word_id': word['word_id'],
        'category_id': 1,
        'word': word['word'],
        'image_asset': 'assets/images/${word['asset']}',
        'description': 'Buah ${word['word']}',
      });
    }

    // Kategori Binatang (category_id: 2)
    final binatangWords = [
      {'word_id': 201, 'word': 'AYAM', 'asset': 'asset-ayam.png'},
      {'word_id': 202, 'word': 'BEBEK', 'asset': 'asset-bebek.png'},
      {'word_id': 203, 'word': 'CICAK', 'asset': 'asset-cicak.png'},
      {'word_id': 204, 'word': 'DOMBA', 'asset': 'asset-domba.png'},
      {'word_id': 205, 'word': 'ELANG', 'asset': 'asset-elang.png'},
    ];

    for (var word in binatangWords) {
      await db.insert('words', {
        'word_id': word['word_id'],
        'category_id': 2,
        'word': word['word'],
        'image_asset': 'assets/images/${word['asset']}',
        'description': 'Binatang ${word['word']}',
      });
    }

    // Kategori Tubuh (category_id: 3)
    final tubuhWords = [
      {'word_id': 301, 'word': 'ALIS', 'asset': 'asset-alis.png'},
      {'word_id': 302, 'word': 'BIBIR', 'asset': 'asset-bibir.png'},
      {'word_id': 303, 'word': 'HIDUNG', 'asset': 'asset-hidung.png'},
      {'word_id': 304, 'word': 'TELINGA', 'asset': 'asset-telinga.png'},
      {'word_id': 305, 'word': 'MATA', 'asset': 'asset-mata.png'},
    ];

    for (var word in tubuhWords) {
      await db.insert('words', {
        'word_id': word['word_id'],
        'category_id': 3,
        'word': word['word'],
        'image_asset': 'assets/images/${word['asset']}',
        'description': 'Bagian tubuh ${word['word']}',
      });
    }

    // Kategori Benda (category_id: 4)
    final bendaWords = [
      {'word_id': 401, 'word': 'KASUR', 'asset': 'asset-kasur.png'},
      {'word_id': 402, 'word': 'KURSI', 'asset': 'asset-kursi.png'},
      {'word_id': 403, 'word': 'LEMARI', 'asset': 'asset-lemari.png'},
      {'word_id': 404, 'word': 'MEJA', 'asset': 'asset-meja.png'},
      {'word_id': 405, 'word': 'SOFA', 'asset': 'asset-sofa.png'},
    ];

    for (var word in bendaWords) {
      await db.insert('words', {
        'word_id': word['word_id'],
        'category_id': 4,
        'word': word['word'],
        'image_asset': 'assets/images/${word['asset']}',
        'description': 'Benda ${word['word']}',
      });
    }

    // Kategori Keluarga (category_id: 5)
    final keluargaWords = [
      {'word_id': 501, 'word': 'BAPAK', 'asset': 'asset-bapak.png'},
      {'word_id': 502, 'word': 'IBU', 'asset': 'asset-ibu.png'},
      {'word_id': 503, 'word': 'KAKEK', 'asset': 'asset-kakek.png'},
      {'word_id': 504, 'word': 'NENEK', 'asset': 'asset-nenek.png'},
      {'word_id': 505, 'word': 'SAUDARA', 'asset': 'asset-saudara.png'},
    ];

    for (var word in keluargaWords) {
      await db.insert('words', {
        'word_id': word['word_id'],
        'category_id': 5,
        'word': word['word'],
        'image_asset': 'assets/images/${word['asset']}',
        'description': 'Anggota keluarga ${word['word']}',
      });
    }

    // Kategori Alfabet (category_id: 6) - tidak ada asset gambar
    final alfabetWords = [
      {'word_id': 601, 'word': 'A'},
      {'word_id': 602, 'word': 'B'},
      {'word_id': 603, 'word': 'C'},
      {'word_id': 604, 'word': 'D'},
      {'word_id': 605, 'word': 'E'},
    ];

    for (var word in alfabetWords) {
      await db.insert('words', {
        'word_id': word['word_id'],
        'category_id': 6,
        'word': word['word'],
        'image_asset': null,
        'description': 'Huruf Alfabet ${word['word']}',
      });
    }

    // ========== INSERT LEVELS ==========
    // Global Sequence untuk Progressive Unlock:
    // 1-5: Alfabet A, B, C, D, E (Mode Alfabet)
    // 6-10: Buah Level 1-5 (Mode Tebak Huruf)
    // 11-15: Binatang Level 1-5 (Mode Tebak Huruf)
    // 16-20: Tubuh Level 1-5 (Mode Tebak Huruf)
    // 21-25: Benda Level 1-5 (Mode Tebak Huruf)
    // 26-30: Keluarga Level 1-5 (Mode Tebak Huruf)

    int globalSeq = 1;

    // Mode Alfabet (mode_id: 2, category_id: 6)
    for (int i = 0; i < 5; i++) {
      await db.insert('levels', {
        'category_id': 6,
        'mode_id': 2,
        'level_number': i + 1,
        'global_sequence': globalSeq++,
        'word_id': 601 + i,
      });
    }

    // Mode Tebak Huruf - Kategori Buah (mode_id: 1, category_id: 1)
    for (int i = 0; i < 5; i++) {
      await db.insert('levels', {
        'category_id': 1,
        'mode_id': 1,
        'level_number': i + 1,
        'global_sequence': globalSeq++,
        'word_id': 101 + i,
      });
    }

    // Mode Tebak Huruf - Kategori Binatang (mode_id: 1, category_id: 2)
    for (int i = 0; i < 5; i++) {
      await db.insert('levels', {
        'category_id': 2,
        'mode_id': 1,
        'level_number': i + 1,
        'global_sequence': globalSeq++,
        'word_id': 201 + i,
      });
    }

    // Mode Tebak Huruf - Kategori Tubuh (mode_id: 1, category_id: 3)
    for (int i = 0; i < 5; i++) {
      await db.insert('levels', {
        'category_id': 3,
        'mode_id': 1,
        'level_number': i + 1,
        'global_sequence': globalSeq++,
        'word_id': 301 + i,
      });
    }

    // Mode Tebak Huruf - Kategori Benda (mode_id: 1, category_id: 4)
    for (int i = 0; i < 5; i++) {
      await db.insert('levels', {
        'category_id': 4,
        'mode_id': 1,
        'level_number': i + 1,
        'global_sequence': globalSeq++,
        'word_id': 401 + i,
      });
    }

    // Mode Tebak Huruf - Kategori Keluarga (mode_id: 1, category_id: 5)
    for (int i = 0; i < 5; i++) {
      await db.insert('levels', {
        'category_id': 5,
        'mode_id': 1,
        'level_number': i + 1,
        'global_sequence': globalSeq++,
        'word_id': 501 + i,
      });
    }

    // ========== INSERT USER PROGRESS ==========
    // Saat install pertama kali:
    // - Hanya Alfabet Level A (global_sequence: 1) yang unlocked
    // - Semua level lainnya locked

    List<Map<String, dynamic>> allLevels = await db.query('levels');

    for (var level in allLevels) {
      int levelId = level['level_id'] as int;
      int globalSeq = level['global_sequence'] as int;

      // Hanya level pertama (Alfabet A) yang unlocked
      bool isUnlocked = globalSeq == 1;

      await db.insert('user_progress', {
        'level_id': levelId,
        'is_unlocked': isUnlocked ? 1 : 0,
        'is_completed': 0,
        'score': 0,
        'stars': 0,
        'completed_at': null,
      });
    }

    print('✅ Initial data inserted successfully');
  }

  // ==================== QUERY METHODS ====================

  /// Get all categories
  Future<List<Map<String, dynamic>>> getAllCategories() async {
    final db = await database;
    return await db.query('categories', orderBy: 'sequence_order ASC');
  }

  /// Get category by ID
  Future<Map<String, dynamic>?> getCategoryById(int categoryId) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'categories',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Get all game modes
  Future<List<Map<String, dynamic>>> getAllGameModes() async {
    final db = await database;
    return await db.query('game_modes');
  }

  /// Get levels by category and mode
  Future<List<Map<String, dynamic>>> getLevelsByCategoryAndMode({
    required int categoryId,
    required int modeId,
  }) async {
    final db = await database;
    return await db.query(
      'levels',
      where: 'category_id = ? AND mode_id = ?',
      whereArgs: [categoryId, modeId],
      orderBy: 'level_number ASC',
    );
  }

  /// Get level with word and progress info
  Future<Map<String, dynamic>?> getLevelWithDetails(int levelId) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT 
        l.*,
        w.word,
        w.image_asset,
        w.description,
        up.is_unlocked,
        up.is_completed,
        up.score,
        up.stars,
        c.name as category_name,
        gm.mode_name
      FROM levels l
      LEFT JOIN words w ON l.word_id = w.word_id
      LEFT JOIN user_progress up ON l.level_id = up.level_id
      LEFT JOIN categories c ON l.category_id = c.category_id
      LEFT JOIN game_modes gm ON l.mode_id = gm.mode_id
      WHERE l.level_id = ?
    ''', [levelId]);

    return result.isNotEmpty ? result.first : null;
  }

  /// Get all levels with details for a category
  Future<List<Map<String, dynamic>>> getLevelsWithDetailsByCategory({
    required int categoryId,
    required int modeId,
  }) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        l.*,
        w.word,
        w.image_asset,
        w.description,
        up.is_unlocked,
        up.is_completed,
        up.score,
        up.stars
      FROM levels l
      LEFT JOIN words w ON l.word_id = w.word_id
      LEFT JOIN user_progress up ON l.level_id = up.level_id
      WHERE l.category_id = ? AND l.mode_id = ?
      ORDER BY l.level_number ASC
    ''', [categoryId, modeId]);
  }

  /// Get category progress summary
  Future<Map<String, dynamic>> getCategoryProgress({
    required int categoryId,
    required int modeId,
  }) async {
    final db = await database;

    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT 
        COUNT(*) as total_levels,
        SUM(CASE WHEN up.is_completed = 1 THEN 1 ELSE 0 END) as completed_levels,
        SUM(CASE WHEN up.is_unlocked = 1 THEN 1 ELSE 0 END) as unlocked_levels
      FROM levels l
      LEFT JOIN user_progress up ON l.level_id = up.level_id
      WHERE l.category_id = ? AND l.mode_id = ?
    ''', [categoryId, modeId]);

    return result.first;
  }

  /// Complete a level and unlock next level
  Future<void> completeLevel({
    required int levelId,
    required int score,
    required int stars,
  }) async {
    final db = await database;

    // Update progress level yang diselesaikan
    await db.update(
      'user_progress',
      {
        'is_completed': 1,
        'score': score,
        'stars': stars,
        'completed_at': DateTime.now().toIso8601String(),
      },
      where: 'level_id = ?',
      whereArgs: [levelId],
    );

    // Ambil global_sequence dari level yang baru diselesaikan
    List<Map<String, dynamic>> currentLevel = await db.query(
      'levels',
      where: 'level_id = ?',
      whereArgs: [levelId],
    );

    if (currentLevel.isNotEmpty) {
      int currentGlobalSeq = currentLevel.first['global_sequence'] as int;

      // Unlock level berikutnya (global_sequence + 1)
      List<Map<String, dynamic>> nextLevel = await db.query(
        'levels',
        where: 'global_sequence = ?',
        whereArgs: [currentGlobalSeq + 1],
      );

      if (nextLevel.isNotEmpty) {
        int nextLevelId = nextLevel.first['level_id'] as int;
        await db.update(
          'user_progress',
          {'is_unlocked': 1},
          where: 'level_id = ?',
          whereArgs: [nextLevelId],
        );
        print('✅ Level $levelId completed. Next level $nextLevelId unlocked.');
      } else {
        print('🎉 Level $levelId completed. All levels finished!');
      }
    }
  }

  /// Check if a level is unlocked
  Future<bool> isLevelUnlocked(int levelId) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'user_progress',
      where: 'level_id = ? AND is_unlocked = 1',
      whereArgs: [levelId],
    );
    return result.isNotEmpty;
  }

  /// Get current unlocked level (untuk navigation ke level terakhir yang dibuka)
  Future<Map<String, dynamic>?> getCurrentUnlockedLevel() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT l.*, up.is_unlocked, up.is_completed
      FROM levels l
      JOIN user_progress up ON l.level_id = up.level_id
      WHERE up.is_unlocked = 1 AND up.is_completed = 0
      ORDER BY l.global_sequence ASC
      LIMIT 1
    ''');
    return result.isNotEmpty ? result.first : null;
  }

  /// Reset all progress (untuk testing)
  Future<void> resetAllProgress() async {
    final db = await database;

    // Reset semua progress
    await db.update('user_progress', {
      'is_unlocked': 0,
      'is_completed': 0,
      'score': 0,
      'stars': 0,
      'completed_at': null,
    });

    // Unlock hanya level pertama (global_sequence: 1)
    List<Map<String, dynamic>> firstLevel = await db.query(
      'levels',
      where: 'global_sequence = 1',
    );

    if (firstLevel.isNotEmpty) {
      int firstLevelId = firstLevel.first['level_id'] as int;
      await db.update(
        'user_progress',
        {'is_unlocked': 1},
        where: 'level_id = ?',
        whereArgs: [firstLevelId],
      );
    }

    print('✅ All progress reset. Only first level unlocked.');
  }

  /// Get word by ID
  Future<Map<String, dynamic>?> getWordById(int wordId) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'words',
      where: 'word_id = ?',
      whereArgs: [wordId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Get all words by category
  Future<List<Map<String, dynamic>>> getWordsByCategory(int categoryId) async {
    final db = await database;
    return await db.query(
      'words',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'word_id ASC',
    );
  }
}
