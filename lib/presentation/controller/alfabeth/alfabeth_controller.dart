import 'package:get/get.dart';
import 'package:alphalearn/database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class AlfabetController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Observable untuk tracking level yang sudah selesai
  RxList<Map<String, dynamic>> levels = <Map<String, dynamic>>[].obs;
  RxBool isLoading = true.obs;

  // Mode ID untuk Alfabet
  final int modeId = 2; // Mode Alfabet
  final int categoryId = 6; // Category Alfabet

  @override
  void onInit() {
    super.onInit();
    developer.log('🎮 AlfabetController initialized',
        name: 'AlfabetController');
    loadLevels();
  }

  /// Load levels dari database
  Future<void> loadLevels() async {
    try {
      developer.log('📝 Loading alfabet levels...', name: 'AlfabetController');
      isLoading.value = true;

      // Load levels dengan detail (word, progress)
      final levelsData = await _dbHelper.getLevelsWithDetailsByCategory(
        categoryId: categoryId,
        modeId: modeId, // Mode Alfabet
      );

      developer.log('📝 Alfabet levels loaded: ${levelsData.length}',
          name: 'AlfabetController');

      for (var level in levelsData) {
        final isUnlocked = level['is_unlocked'] == 1;
        final isCompleted = level['is_completed'] == 1;
        developer.log(
            '  - Level ${level['word']}: '
            '(Unlocked: $isUnlocked, Completed: $isCompleted)',
            name: 'AlfabetController');
      }

      levels.value = levelsData;
    } catch (e, stackTrace) {
      developer.log(
        '❌ Error loading alfabet levels: $e',
        name: 'AlfabetController',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Cek apakah level sudah selesai
  bool isLevelCompleted(String level) {
    final levelData = levels.firstWhereOrNull((l) => l['word'] == level);
    if (levelData == null) return false;
    return levelData['is_completed'] == 1;
  }

  // Cek apakah level terkunci
  bool isLevelLocked(String level) {
    final levelData = levels.firstWhereOrNull((l) => l['word'] == level);
    if (levelData == null) return true;
    return levelData['is_unlocked'] == 0;
  }

  // Tandai level sebagai selesai dan unlock next level
  Future<void> completeLevel(String level) async {
    try {
      // Find level ID
      final levelData = levels.firstWhereOrNull((l) => l['word'] == level);
      if (levelData == null) {
        developer.log('❌ Level not found: $level', name: 'AlfabetController');
        return;
      }

      final levelId = levelData['level_id'] as int;

      // Complete level di database (otomatis unlock next level)
      await _dbHelper.completeLevel(
        levelId: levelId,
        score: 100, // Perfect score untuk alfabet
        stars: 3, // 3 stars untuk alfabet
      );

      // Set flag untuk refresh UI menu page
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('alfabet_need_refresh', true);

      // Reload levels untuk update UI
      await loadLevels();
    } catch (e, stackTrace) {
      developer.log(
        '❌ Error completing alfabet level: $e',
        name: 'AlfabetController',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // Reset semua progress (untuk testing)
  Future<void> resetProgress() async {
    try {
      await _dbHelper.resetAllProgress();
      await loadLevels();
      developer.log('✅ Alfabet progress reset', name: 'AlfabetController');
    } catch (e) {
      developer.log('❌ Error resetting progress: $e',
          name: 'AlfabetController');
    }
  }
}
