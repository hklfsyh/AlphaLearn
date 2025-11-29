import 'dart:developer' as developer;
import 'dart:math';

import 'package:alphalearn/core/core.dart';
import 'package:alphalearn/database/database_helper.dart';
import 'package:alphalearn/presentation/widget/puzzle_result_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PuzzleController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Observable variables
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> levels = <Map<String, dynamic>>[].obs;

  final RxInt currentLevelId = 0.obs;
  final RxInt currentCategoryId = 0.obs;
  final RxInt currentWordId = 0.obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxInt totalQuestions = 0.obs; // Total huruf dalam kata
  final RxInt score = 0.obs;
  final RxInt hiddenLetterIndex = 0.obs;

  final RxBool isLoading = true.obs;
  final RxBool isAnswered = false.obs;
  final RxString selectedAnswer = ''.obs;
  final RxString correctAnswer = ''.obs;
  final RxList<String> answerOptions = <String>[].obs;
  final RxList<int> completedLetterIndexes =
      <int>[].obs; // Track huruf yang sudah benar

  final int modeId = 1; // Tebak Huruf

  final RxString currentImage = ''.obs;

  // ==========================================
  // BYPASS MODE - Set true untuk testing tanpa lock
  // Set false untuk production dengan lock system
  // ==========================================
  final bool bypassLock =
      false; // <-- FALSE = PRODUCTION MODE dengan progressive unlock

  @override
  void onInit() {
    super.onInit();
    developer.log('🎮 PuzzleController initialized (bypassLock: $bypassLock)',
        name: 'PuzzleController');
    loadCategories();
  }

  @override
  void onClose() {
    developer.log('🎮 PuzzleController disposed', name: 'PuzzleController');
    super.onClose();
  }

  Future<void> loadCategories() async {
    try {
      developer.log('📂 Loading categories...', name: 'PuzzleController');
      isLoading.value = true;

      await Future.delayed(const Duration(milliseconds: 800));

      final allCategories = await _dbHelper.getAllCategories();
      developer.log('📂 Total categories from DB: ${allCategories.length}',
          name: 'PuzzleController');

      // Filter: hanya category 1-5, exclude Alfabet (6)
      categories.value = allCategories.where((cat) {
        final categoryId = cat['category_id'] as int;
        final shouldInclude = categoryId >= 1 && categoryId <= 5;

        developer.log(
            '📂 Category $categoryId (${cat['name']}): included=$shouldInclude',
            name: 'PuzzleController');

        return shouldInclude;
      }).toList();

      developer.log('📂 Filtered categories: ${categories.length}',
          name: 'PuzzleController');

      // Sort by category_id (simple sort)
      categories.sort((a, b) {
        final idA = a['category_id'] as int? ?? 0;
        final idB = b['category_id'] as int? ?? 0;
        return idA.compareTo(idB);
      });

      developer.log('📂 Categories loaded:', name: 'PuzzleController');
      for (var cat in categories) {
        developer.log('  - ${cat['category_id']}: ${cat['name']}',
            name: 'PuzzleController');
      }
    } catch (e, stackTrace) {
      developer.log(
        '❌ Error loading categories: $e',
        name: 'PuzzleController',
        error: e,
        stackTrace: stackTrace,
      );
      Get.snackbar('Error', 'Gagal memuat kategori: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadLevels(int categoryId) async {
    try {
      developer.log('📝 Loading levels for category: $categoryId',
          name: 'PuzzleController');
      isLoading.value = true;
      currentCategoryId.value = categoryId;

      await Future.delayed(const Duration(milliseconds: 600));

      // Load levels dengan detail (word, image_asset, progress)
      final levelsData = await _dbHelper.getLevelsWithDetailsByCategory(
        categoryId: categoryId,
        modeId: modeId, // Mode Tebak Huruf
      );

      developer.log('📝 Levels loaded: ${levelsData.length}',
          name: 'PuzzleController');

      if (levelsData.isEmpty) {
        developer.log('⚠️ No levels found for category $categoryId',
            name: 'PuzzleController');
        Get.snackbar(
          'Info',
          'Belum ada level untuk kategori ini',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        developer.log('📝 Levels:', name: 'PuzzleController');
        for (var level in levelsData) {
          final isUnlocked = level['is_unlocked'] == 1;
          final isCompleted = level['is_completed'] == 1;
          developer.log(
              '  - Level ${level['level_number']}: ${level['word']} '
              '(Unlocked: $isUnlocked, Completed: $isCompleted)',
              name: 'PuzzleController');
        }
      }

      levels.value = levelsData;
    } catch (e, stackTrace) {
      developer.log(
        '❌ Error loading levels: $e',
        name: 'PuzzleController',
        error: e,
        stackTrace: stackTrace,
      );
      Get.snackbar('Error', 'Gagal memuat level: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startLevel(int levelId, String word,
      {String? imageAsset}) async {
    try {
      developer.log('🎯 Starting level: levelId=$levelId, word=$word',
          name: 'PuzzleController');
      isLoading.value = true;

      await Future.delayed(const Duration(milliseconds: 500));

      currentLevelId.value = levelId;

      // Get level details dari database
      final levelData = await _dbHelper.getLevelWithDetails(levelId);
      if (levelData != null) {
        currentWordId.value = levelData['word_id'] ?? 0;
        currentCategoryId.value = levelData['category_id'] ?? 0;
      }

      correctAnswer.value = word.toUpperCase();
      currentImage.value = imageAsset ?? 'assets/images/apel_level_img.png';

      currentQuestionIndex.value = 0;
      totalQuestions.value = word.length; // Total huruf dalam kata
      score.value = 0;
      isAnswered.value = false;
      selectedAnswer.value = '';
      completedLetterIndexes.clear(); // Reset huruf yang sudah benar

      developer.log(
          '🎯 Level state reset - Total questions: ${totalQuestions.value}',
          name: 'PuzzleController');

      generateQuestion();
    } catch (e, stackTrace) {
      developer.log(
        '❌ Error starting level: $e',
        name: 'PuzzleController',
        error: e,
        stackTrace: stackTrace,
      );
      Get.snackbar('Error', 'Gagal memulai level: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void generateQuestion() {
    developer.log('🎲 Generating question...', name: 'PuzzleController');

    final word = correctAnswer.value;
    if (word.isEmpty) {
      developer.log('⚠️ Word is empty!', name: 'PuzzleController');
      return;
    }

    // Pilih huruf yang belum selesai
    final Random random = Random();
    List<int> availableIndexes = [];
    for (int i = 0; i < word.length; i++) {
      if (!completedLetterIndexes.contains(i)) {
        availableIndexes.add(i);
      }
    }

    if (availableIndexes.isEmpty) {
      developer.log('🏁 All letters completed!', name: 'PuzzleController');
      return;
    }

    // Pilih index huruf yang akan ditebak
    hiddenLetterIndex.value =
        availableIndexes[random.nextInt(availableIndexes.length)];
    final correctLetter = word[hiddenLetterIndex.value];

    developer.log(
        '🎲 Word: $word, Hidden index: ${hiddenLetterIndex.value}, '
        'Correct letter: $correctLetter',
        name: 'PuzzleController');

    // Generate 3 huruf salah
    final List<String> wrongLetters = [];
    const String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    while (wrongLetters.length < 3) {
      final randomLetter = alphabet[random.nextInt(alphabet.length)];
      if (randomLetter != correctLetter &&
          !wrongLetters.contains(randomLetter)) {
        wrongLetters.add(randomLetter);
      }
    }

    // Gabung dan shuffle
    final List<String> options = [correctLetter, ...wrongLetters];
    options.shuffle();
    answerOptions.value = options;

    developer.log('🎲 Answer options: $options', name: 'PuzzleController');
  }

  void checkAnswer(String answer) {
    if (isAnswered.value) {
      developer.log('⚠️ Already answered', name: 'PuzzleController');
      return;
    }

    developer.log('✅ Checking answer: $answer', name: 'PuzzleController');

    selectedAnswer.value = answer;
    isAnswered.value = true;
    final correctLetter = correctAnswer.value[hiddenLetterIndex.value];

    developer.log('✅ Selected: $answer, Correct: $correctLetter',
        name: 'PuzzleController');

    if (answer == correctLetter) {
      score.value++;
      completedLetterIndexes
          .add(hiddenLetterIndex.value); // Track huruf yang benar
      currentQuestionIndex.value++;

      developer.log('🎉 Correct! Score: ${score.value}/${totalQuestions.value}',
          name: 'PuzzleController');

      Get.snackbar(
        'Benar! 🎉',
        'Jawabanmu tepat!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );

      // Delay lalu lanjut ke huruf berikutnya atau selesai
      Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
        isAnswered.value = false;
        selectedAnswer.value = '';

        // Cek apakah semua huruf sudah selesai
        if (completedLetterIndexes.length >= totalQuestions.value) {
          developer.log('🏆 All letters completed! Finishing level...',
              name: 'PuzzleController');
          finishLevel();
        } else {
          developer.log('➡️ Next letter...', name: 'PuzzleController');
          generateQuestion(); // Generate soal baru
        }
      });
    } else {
      developer.log('❌ Wrong!', name: 'PuzzleController');

      Get.snackbar(
        'Salah 😢',
        'Coba lagi!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );

      // Reset state untuk coba lagi (tidak keluar dari level)
      Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
        isAnswered.value = false;
        selectedAnswer.value = '';
      });
    }
  }

  Future<void> finishLevel() async {
    try {
      final isCorrect = score.value > 0;
      final stars = _calculateStars();

      // Update database: complete level & unlock next
      await _dbHelper.completeLevel(
        levelId: currentLevelId.value,
        score: score.value * 10, // Score multiplier
        stars: stars,
      );

      // Set flag untuk refresh UI level page
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('puzzle_need_refresh', true);

      PuzzleResultDialog.show(
        isCorrect: isCorrect,
        word: correctAnswer.value,
        onBack: () {
          Get.back(); // Close dialog
          Get.back(); // Back to level page
        },
        onRetry: () {
          Get.back(); // Close dialog
          startLevel(
            currentLevelId.value,
            correctAnswer.value,
            imageAsset: currentImage.value,
          );
        },
      );
    } catch (e, stackTrace) {
      developer.log(
        '❌ Error finishing level: $e',
        name: 'PuzzleController',
        error: e,
        stackTrace: stackTrace,
      );
      Get.snackbar('Error', 'Gagal menyimpan progress: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  int _calculateStars() {
    final totalLetters = totalQuestions.value;
    final correctAnswers = score.value;

    if (correctAnswers == totalLetters) {
      return 3; // Perfect!
    } else if (correctAnswers >= (totalLetters * 0.7)) {
      return 2; // Good
    } else if (correctAnswers >= (totalLetters * 0.5)) {
      return 1; // OK
    }
    return 0; // Need improvement
  }

  // ==========================================
  // CHECK LOCK/UNLOCK STATUS
  // ==========================================

  /// Check if category is locked
  /// In production mode: check based on previous category completion
  /// In bypass mode: always unlocked
  Future<bool> isCategoryLocked(int categoryId) async {
    // Bypass mode: semua unlocked
    if (bypassLock) {
      developer.log('🔓 BYPASS: Category $categoryId is UNLOCKED',
          name: 'PuzzleController');
      return false;
    }

    // Production mode: check based on category progress
    developer.log('🔒 Checking lock for category $categoryId',
        name: 'PuzzleController');

    try {
      // Get progress summary untuk kategori ini
      final progress = await _dbHelper.getCategoryProgress(
        categoryId: categoryId,
        modeId: modeId,
      );

      final unlockedLevels = progress['unlocked_levels'] ?? 0;
      final isLocked = unlockedLevels == 0;

      developer.log(
          '🔒 Category $categoryId: unlocked_levels=$unlockedLevels, locked=$isLocked',
          name: 'PuzzleController');

      return isLocked;
    } catch (e) {
      developer.log('❌ Error checking lock status: $e',
          name: 'PuzzleController');
      return true; // Default: locked jika error
    }
  }

  /// Check if level is unlocked
  Future<bool> isLevelUnlocked(int levelId) async {
    if (bypassLock) return true;

    try {
      return await _dbHelper.isLevelUnlocked(levelId);
    } catch (e) {
      developer.log('❌ Error checking level unlock: $e',
          name: 'PuzzleController');
      return false;
    }
  }

  /// Check if level is completed
  Future<bool> isLevelCompleted(int levelId) async {
    if (bypassLock) return false;

    try {
      final levelData = await _dbHelper.getLevelWithDetails(levelId);
      return levelData?['is_completed'] == 1;
    } catch (e) {
      developer.log('❌ Error checking level completion: $e',
          name: 'PuzzleController');
      return false;
    }
  }
}
