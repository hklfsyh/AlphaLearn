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

  @override
  void onInit() {
    super.onInit();
    developer.log('🎮 PuzzleController initialized', name: 'PuzzleController');
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

      final allCategories = await _dbHelper.getAllCategories();
      developer.log('📂 Total categories from DB: ${allCategories.length}',
          name: 'PuzzleController');

      // UBAH: Hanya filter berdasarkan category_id, bukan is_categorized_level
      categories.value = allCategories.where((cat) {
        final categoryId = cat['category_id'] as int;

        developer.log(
            '📂 Category ${cat['category_id']} (${cat['name']}): '
            'checking categoryId...',
            name: 'PuzzleController');

        // Include category 1-5 (Buah, Binatang, Tubuh, Benda, Keluarga)
        // Exclude category 6 (Alfabet)
        final shouldInclude = categoryId >= 1 && categoryId <= 5;

        developer.log(
            '📂 Category $categoryId (${cat['name']}): included=$shouldInclude',
            name: 'PuzzleController');

        return shouldInclude;
      }).toList();

      developer.log('📂 Filtered categories: ${categories.length}',
          name: 'PuzzleController');

      categories.sort((a, b) {
        final orderA = a['sequence_order'] as int? ?? 0;
        final orderB = b['sequence_order'] as int? ?? 0;
        return orderA.compareTo(orderB);
      });

      developer.log('📂 Categories loaded and sorted:',
          name: 'PuzzleController');
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
      developer.log(
          '📂 isLoading set to false, categories.length=${categories.length}',
          name: 'PuzzleController');
    }
  }

  Future<void> loadLevels(int categoryId) async {
    try {
      developer.log('📝 Loading levels for category: $categoryId',
          name: 'PuzzleController');
      isLoading.value = true;
      currentCategoryId.value = categoryId;

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
      developer.log('📝 isLoading set to false', name: 'PuzzleController');
    }
  }

  Future<void> startLevel(int wordId, String word) async {
    try {
      developer.log('🎯 Starting level: wordId=$wordId, word=$word',
          name: 'PuzzleController');
      isLoading.value = true;
      currentWordId.value = wordId;
      correctAnswer.value = word.toUpperCase();

      currentQuestionIndex.value = 0;
      score.value = 0;
      isAnswered.value = false;
      selectedAnswer.value = '';

      developer.log('🎯 Level state reset: score=0, isAnswered=false',
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
      developer.log('🎯 isLoading set to false', name: 'PuzzleController');
    }
  }

  void generateQuestion() {
    developer.log('🎲 Generating question...', name: 'PuzzleController');

    final word = correctAnswer.value;
    if (word.isEmpty) {
      developer.log('⚠️ Word is empty, cannot generate question',
          name: 'PuzzleController');
      return;
    }

    final Random random = Random();
    hiddenLetterIndex.value = random.nextInt(word.length);
    final correctLetter = word[hiddenLetterIndex.value];

    developer.log(
        '🎲 Word: $word, Hidden index: ${hiddenLetterIndex.value}, Correct letter: $correctLetter',
        name: 'PuzzleController');

    final List<String> wrongLetter = [];
    const String alfabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    while (wrongLetter.length < 3) {
      final randomLetter = alfabet[random.nextInt(alfabet.length)];
      if (randomLetter != correctLetter &&
          !wrongLetter.contains(randomLetter)) {
        wrongLetter.add(randomLetter);
      }
    }

    final List<String> options = [correctLetter, ...wrongLetter];
    options.shuffle();
    answerOptions.value = options;

    developer.log('🎲 Answer options: $options', name: 'PuzzleController');
  }

  void checkAnswer(String answer) {
    if (isAnswered.value) {
      developer.log('⚠️ Already answered, ignoring', name: 'PuzzleController');
      return;
    }

    developer.log('✅ Checking answer: $answer', name: 'PuzzleController');

    selectedAnswer.value = answer;
    isAnswered.value = true;
    final correctLetter = correctAnswer.value[hiddenLetterIndex.value];

    developer.log(
        '✅ Selected: $answer, Correct: $correctLetter, Match: ${answer == correctLetter}',
        name: 'PuzzleController');

    if (answer == correctLetter) {
      score.value++;
      developer.log('🎉 Correct answer! Score: ${score.value}',
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
        developer.log('⏰ Delayed finishLevel called', name: 'PuzzleController');
        finishLevel();
      });
    } else {
      developer.log('❌ Wrong answer!', name: 'PuzzleController');

      Get.snackbar(
        'Salah 😢',
        'Jawaban yang benar: $correctLetter',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Give one more try
      Future.delayed(const Duration(seconds: 2), () {
        developer.log('⏰ Resetting for retry', name: 'PuzzleController');
        isAnswered.value = false;
        selectedAnswer.value = '';
      });
    }
  }

  Future<void> finishLevel() async {
    try {
      developer.log('🏁 Finishing level...', name: 'PuzzleController');

      final isCorrect = score.value > 0;
      developer.log('🏁 Is correct: $isCorrect, Score: ${score.value}',
          name: 'PuzzleController');

      developer.log('💾 Updating activity completion...',
          name: 'PuzzleController');
      await _dbHelper.updateActivityCompletion(
        wordId: currentWordId.value,
        modeId: modeId,
        isCompleted: isCorrect,
      );
      developer.log('💾 Activity completion updated', name: 'PuzzleController');

      developer.log('💾 Getting user progress...', name: 'PuzzleController');
      final progress =
          await _dbHelper.getUserProgressByCategory(currentCategoryId.value);
      developer.log('💾 Current progress: $progress', name: 'PuzzleController');

      if (progress != null) {
        final currentScore =
            (progress['current_score'] as int? ?? 0) + (isCorrect ? 1 : 0);
        final maxQuestions = progress['max_questions'] as int? ?? 0;

        developer.log('💾 Updating progress: $currentScore/$maxQuestions',
            name: 'PuzzleController');

        await _dbHelper.updateUserProgress(
          categoryId: currentCategoryId.value,
          currentScore: currentScore,
          isCompleted: currentScore >= maxQuestions,
        );
        developer.log('💾 User progress updated', name: 'PuzzleController');
      }

      developer.log('📢 Showing completion dialog', name: 'PuzzleController');

      Get.dialog(
        AlertDialog(
          title: Text(isCorrect ? 'Selesai! 🎊' : 'Coba Lagi 😊'),
          content: Text(
            isCorrect
                ? 'Kamu berhasil menebak kata "${correctAnswer.value}" dengan benar!'
                : 'Jangan menyerah! Coba lagi untuk menyelesaikan level ini.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                developer.log('👈 Back button pressed',
                    name: 'PuzzleController');
                Get.back(); // Close dialog
                Get.back(); // Back to level selection
              },
              child: const Text('Kembali'),
            ),
            if (!isCorrect)
              ElevatedButton(
                onPressed: () {
                  developer.log('🔄 Retry button pressed',
                      name: 'PuzzleController');
                  Get.back(); // Close dialog
                  startLevel(currentWordId.value, correctAnswer.value);
                },
                child: const Text('Main Lagi'),
              ),
            if (isCorrect)
              ElevatedButton(
                onPressed: () {
                  developer.log('➡️ Next level button pressed',
                      name: 'PuzzleController');
                  Get.back(); // Close dialog
                  Get.back(); // Back to level selection
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
      Get.snackbar(
        'Error',
        'Gagal menyimpan progress: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<bool> isCategoryLocked(int categoryId) async {
    developer.log('🔒 Checking if category $categoryId is locked',
        name: 'PuzzleController');

    if (categoryId == 1) {
      final alfabetProgress = await _dbHelper.getUserProgressByCategory(6);
      final isLocked = alfabetProgress?['is_completed'] != 1 &&
          alfabetProgress?['is_completed'] != true;
      developer.log('🔒 Category 1 locked: $isLocked (depends on Alfabet)',
          name: 'PuzzleController');
      return isLocked;
    }

    if (categoryId > 1 && categoryId <= 5) {
      final previousProgress =
          await _dbHelper.getUserProgressByCategory(categoryId - 1);
      final isLocked = previousProgress?['is_completed'] != 1 &&
          previousProgress?['is_completed'] != true;
      developer.log(
          '🔒 Category $categoryId locked: $isLocked (depends on category ${categoryId - 1})',
          name: 'PuzzleController');
      return isLocked;
    }

    developer.log('🔒 Category $categoryId is unlocked',
        name: 'PuzzleController');
    return false;
  }

  Future<bool> isLevelCompleted(int wordId) async {
    final isCompleted = await _dbHelper.isWordCompletedInMode(wordId, modeId);
    developer.log('✔️ Level $wordId completed: $isCompleted',
        name: 'PuzzleController');
    return isCompleted;
  }
}
