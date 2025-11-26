import 'dart:developer' as developer;
import 'dart:math';

import 'package:alphalearn/core/core.dart';
import 'package:alphalearn/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PuzzleController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Observable variables
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> levels = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> words = <Map<String, dynamic>>[].obs;

  final RxInt currentCategoryId = 0.obs;
  final RxInt currentWordId = 0.obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxInt score = 0.obs;
  final RxInt hiddenLetterIndex = 0.obs;

  final RxBool isLoading = true.obs;
  final RxBool isAnswered = false.obs;
  final RxString selectedAnswer = ''.obs;
  final RxString correctAnswer = ''.obs;
  final RxList<String> answerOptions = <String>[].obs;

  final int modeId = 1; // Tebak Huruf

  // ==========================================
  // BYPASS MODE - Set true untuk testing
  // Set false untuk production dengan lock system
  // ==========================================
  final bool bypassLock = true; // <-- UBAH KE FALSE UNTUK PRODUCTION

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

      final contentWords =
          await _dbHelper.getContentWordsByCategory(categoryId);
      developer.log('📝 Content words loaded: ${contentWords.length}',
          name: 'PuzzleController');

      if (contentWords.isEmpty) {
        developer.log('⚠️ No levels found for category $categoryId',
            name: 'PuzzleController');
        Get.snackbar(
          'Info',
          'Belum ada level untuk kategori ini',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        developer.log('📝 Levels:', name: 'PuzzleController');
        for (var word in contentWords) {
          developer.log('  - ${word['word_id']}: ${word['word']}',
              name: 'PuzzleController');
        }
      }

      levels.value = contentWords;
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

  Future<void> startLevel(int wordId, String word) async {
    try {
      developer.log('🎯 Starting level: wordId=$wordId, word=$word',
          name: 'PuzzleController');
      isLoading.value = true;

      await Future.delayed(const Duration(milliseconds: 500));

      currentWordId.value = wordId;
      correctAnswer.value = word.toUpperCase();

      currentQuestionIndex.value = 0;
      score.value = 0;
      isAnswered.value = false;
      selectedAnswer.value = '';

      developer.log('🎯 Level state reset', name: 'PuzzleController');

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

    final Random random = Random();
    hiddenLetterIndex.value = random.nextInt(word.length);
    final correctLetter = word[hiddenLetterIndex.value];

    developer.log(
        '🎲 Word: $word, Hidden index: ${hiddenLetterIndex.value}, '
        'Correct letter: $correctLetter',
        name: 'PuzzleController');

    final List<String> wrongLetters = [];
    const String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    while (wrongLetters.length < 3) {
      final randomLetter = alphabet[random.nextInt(alphabet.length)];
      if (randomLetter != correctLetter &&
          !wrongLetters.contains(randomLetter)) {
        wrongLetters.add(randomLetter);
      }
    }

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
      developer.log('🎉 Correct! Score: ${score.value}',
          name: 'PuzzleController');

      Get.snackbar(
        'Benar! 🎉',
        'Jawabanmu tepat!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );

      Future.delayed(const Duration(seconds: 2), () {
        finishLevel();
      });
    } else {
      developer.log('❌ Wrong!', name: 'PuzzleController');

      Get.snackbar(
        'Salah 😢',
        'Jawaban yang benar: $correctLetter',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      Future.delayed(const Duration(seconds: 2), () {
        isAnswered.value = false;
        selectedAnswer.value = '';
      });
    }
  }

  Future<void> finishLevel() async {
    try {
      developer.log('🏁 Finishing level...', name: 'PuzzleController');

      final isCorrect = score.value > 0;

      // Skip database update saat bypass mode (optional)
      if (!bypassLock) {
        await _dbHelper.updateActivityCompletion(
          wordId: currentWordId.value,
          modeId: modeId,
          isCompleted: isCorrect,
        );

        final progress =
            await _dbHelper.getUserProgressByCategory(currentCategoryId.value);

        if (progress != null) {
          final currentScore =
              (progress['current_score'] as int? ?? 0) + (isCorrect ? 1 : 0);
          final maxQuestions = progress['max_questions'] as int? ?? 0;

          await _dbHelper.updateUserProgress(
            categoryId: currentCategoryId.value,
            currentScore: currentScore,
            isCompleted: currentScore >= maxQuestions,
          );
        }
      }

      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            isCorrect ? 'Selesai! 🎊' : 'Coba Lagi 😊',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            isCorrect
                ? 'Kamu berhasil menebak kata "${correctAnswer.value}" dengan benar!'
                : 'Jangan menyerah! Coba lagi untuk menyelesaikan level ini.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog
                Get.back(); // Back to level selection
              },
              child: const Text('Kembali'),
            ),
            if (!isCorrect)
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  startLevel(currentWordId.value, correctAnswer.value);
                },
                child: const Text('Main Lagi'),
              ),
            if (isCorrect)
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                child: const Text('Level Berikutnya'),
              )
          ],
        ),
        barrierDismissible: false,
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

  // ==========================================
  // BYPASS: Semua kategori UNLOCKED
  // ==========================================
  Future<bool> isCategoryLocked(int categoryId) async {
    // Bypass mode: semua unlocked
    if (bypassLock) {
      developer.log('🔓 BYPASS: Category $categoryId is UNLOCKED',
          name: 'PuzzleController');
      return false; // Tidak terkunci
    }

    // Production mode: cek lock berdasarkan progress
    developer.log('🔒 Checking lock for category $categoryId',
        name: 'PuzzleController');

    if (categoryId == 1) {
      final alfabetProgress = await _dbHelper.getUserProgressByCategory(6);
      return alfabetProgress?['is_completed'] != 1;
    }

    if (categoryId > 1 && categoryId <= 5) {
      final previousProgress =
          await _dbHelper.getUserProgressByCategory(categoryId - 1);
      return previousProgress?['is_completed'] != 1;
    }

    return false;
  }

  Future<bool> isLevelCompleted(int wordId) async {
    // Bypass mode: semua belum selesai (untuk testing)
    if (bypassLock) {
      return false;
    }

    return await _dbHelper.isWordCompletedInMode(wordId, modeId);
  }
}
