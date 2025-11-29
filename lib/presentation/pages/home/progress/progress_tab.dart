import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../database/database_helper.dart';

class ProgressTab extends StatefulWidget {
  const ProgressTab({super.key});

  @override
  State<ProgressTab> createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> categories = [];
  Map<int, Map<String, dynamic>> progressData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgressData();
  }

  /// Load progress data dari database untuk semua kategori
  Future<void> _loadProgressData() async {
    setState(() => isLoading = true);

    try {
      // Get semua kategori kecuali Alfabet (category_id: 6)
      final allCategories = await dbHelper.getAllCategories();
      final tebakHurufCategories =
          allCategories.where((cat) => cat['category_id'] != 6).toList();

      // Get progress untuk setiap kategori di mode Tebak Huruf
      Map<int, Map<String, dynamic>> tempProgress = {};
      for (var category in tebakHurufCategories) {
        int categoryId = category['category_id'];

        // Get progress summary
        final progress = await dbHelper.getCategoryProgress(
          categoryId: categoryId,
          modeId: 1, // Mode Tebak Huruf
        );

        tempProgress[categoryId] = progress;
      }

      setState(() {
        categories = tebakHurufCategories;
        progressData = tempProgress;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading progress: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Progres Kamu',
          style: TextStyle(
              color: Color(0xFF45513C),
              fontFamily: 'assets/fonts/nunito_bold.ttf',
              shadows: [
                Shadow(
                  offset: Offset(0.5, 0.5),
                  blurRadius: 2.0,
                  color: Colors.grey,
                ),
              ]),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: AppSizes.paddingAllLg,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  childAspectRatio: 0.95, // Disesuaikan untuk card baru
                  crossAxisSpacing: AppSizes.paddingLg,
                  mainAxisSpacing: AppSizes.paddingLg,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final progress = progressData[category['category_id']]!;

                  String name = category['name'];
                  String iconPath = category['icon_path'] ?? '';

                  // Data dari database (dinamis!)
                  int completedLevels = progress['completed_levels'] ?? 0;
                  int totalLevels = progress['total_levels'] ?? 5;
                  int unlockedLevels = progress['unlocked_levels'] ?? 0;

                  // Locked jika tidak ada level yang unlocked
                  bool isLocked = unlockedLevels == 0;

                  return _CategoryCard(
                    name: name,
                    imagePath: iconPath,
                    currentLevel: completedLevels,
                    maxLevel: totalLevels,
                    isLocked: isLocked,
                    backgroundColor: _getBackgroundColor(name),
                    progressBarColor: _getProgressBarColor(name),
                  );
                },
              ),
            ),
    );
  }

  Color _getBackgroundColor(String categoryName) {
    switch (categoryName) {
      case 'Buah':
        return const Color(0xFFE39D96);
      case 'Binatang':
        return const Color(0xFF2E6F40).withOpacity(0.64);
      case 'Tubuh':
        return const Color(0xFFDDBF71);
      case 'Benda':
        return const Color(0xFF724935).withOpacity(0.64);
      case 'Keluarga':
        return const Color(0xFF44ED9B).withOpacity(0.64);
      default:
        return Colors.grey;
    }
  }

  Color _getProgressBarColor(String categoryName) {
    switch (categoryName) {
      case 'Buah':
        return const Color(0xFFC7372F);
      case 'Binatang':
        return const Color(0xFF2A5731);
      case 'Tubuh':
        return const Color(0xFFC9AC61);
      case 'Benda':
        return const Color(0xFF724935);
      case 'Keluarga':
        return const Color(0xFF44ED9B);
      default:
        return Colors.grey;
    }
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final int currentLevel;
  final int maxLevel;
  final bool isLocked;
  final Color backgroundColor;
  final Color progressBarColor;

  const _CategoryCard({
    required this.name,
    required this.imagePath,
    required this.currentLevel,
    required this.maxLevel,
    required this.isLocked,
    required this.backgroundColor,
    required this.progressBarColor,
  });

  @override
  Widget build(BuildContext context) {
    // Hitung progress (0.0 - 1.0)
    final progress = maxLevel > 0 ? currentLevel / maxLevel : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLocked ? Colors.black.withOpacity(0.8) : backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nama kategori
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Fredoka',
            ),
            textAlign: TextAlign.center,
          ),

          // Asset gambar (transparan)
          if (!isLocked)
            Expanded(
              child: Center(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported,
                      size: 60,
                      color: Colors.white.withOpacity(0.5),
                    );
                  },
                ),
              ),
            )
          else
            const Expanded(
              child: Center(
                child: Icon(
                  Icons.lock,
                  size: 56,
                  color: Colors.white,
                ),
              ),
            ),

          // Progress bar dan teks Now/Max
          if (!isLocked)
            Column(
              children: [
                const SizedBox(height: 8),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 6),
                // Teks Now/Max
                Text(
                  '[$currentLevel/$maxLevel]',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Fredoka',
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
