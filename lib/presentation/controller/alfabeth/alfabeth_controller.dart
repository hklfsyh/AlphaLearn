import 'package:get/get.dart';
import '../../../database/database_helper.dart';

class AlfabetController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Observable lists
  final RxList<Map<String, dynamic>> levels = <Map<String, dynamic>>[].obs;
  final RxList<int> unlockedLetters = <int>[].obs;
  final RxList<int> completedLetters = <int>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadLevels();
  }

  Future<void> loadLevels() async {
    try {
      isLoading.value = true;

      // Load levels from database or JSON
      final allLevels = await _dbHelper.getContentWordsByCategory(6);
      levels.value = allLevels;

      // Unlock A–E by default
      unlockedLetters.value = allLevels
        .where((level) => level['word_id'] <= 601)
        .map((level) => level['word_id'] as int)
        .toList();
      
      completedLetters.value = [];
    } catch (e) {
      print('Error loading levels: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool isLetterLocked(int wordId) {
    return !unlockedLetters.contains(wordId);
  }

  bool isLetterCompleted(int wordId) {
    return completedLetters.contains(wordId);
  }

  Future<void> markLetterCompleted(int wordId) async {
    if (!completedLetters.contains(wordId)) {
      completedLetters.add(wordId);

      // Unlock the next letter
      final nextIndex = levels.firstWhereOrNull(
        (level) => level['word_id'] == wordId + 1
      );
      if (nextIndex != null) {
        unlockedLetters.add(nextIndex['word_id'] as int);
      }
    }
  }
}