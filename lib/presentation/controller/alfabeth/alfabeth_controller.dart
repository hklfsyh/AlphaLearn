import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlfabetController extends GetxController {
  // Key untuk shared preferences
  static const String _keyCompletedLevels = 'completed_alfabet_levels';

  // Observable untuk tracking level yang sudah selesai
  RxList<String> completedLevels = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCompletedLevels();
  }

  // Load completed levels dari shared preferences
  Future<void> _loadCompletedLevels() async {
    final prefs = await SharedPreferences.getInstance();
    final levels = prefs.getStringList(_keyCompletedLevels) ?? [];
    completedLevels.value = levels;
  }

  // Cek apakah level sudah selesai
  bool isLevelCompleted(String level) {
    return completedLevels.contains(level);
  }

  // Cek apakah level terkunci
  bool isLevelLocked(String level) {
    // Level A selalu terbuka
    if (level == 'A') return false;

    // List urutan level
    const levelOrder = ['A', 'B', 'C', 'D', 'E'];
    final currentIndex = levelOrder.indexOf(level);

    if (currentIndex <= 0) return false;

    // Level terkunci jika level sebelumnya belum selesai
    final previousLevel = levelOrder[currentIndex - 1];
    return !isLevelCompleted(previousLevel);
  }

  // Tandai level sebagai selesai
  Future<void> completeLevel(String level) async {
    if (!completedLevels.contains(level)) {
      completedLevels.add(level);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_keyCompletedLevels, completedLevels);
    }
  }

  // Reset semua progress (untuk testing)
  Future<void> resetProgress() async {
    completedLevels.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCompletedLevels);
  }
}
