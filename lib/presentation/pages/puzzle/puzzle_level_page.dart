import 'package:alphalearn/presentation/widget/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/core.dart';
import '../../controller/puzzle/puzzle_controller.dart';

class PuzzleLevelPage extends StatefulWidget {
  const PuzzleLevelPage({super.key});

  @override
  State<PuzzleLevelPage> createState() => _PuzzleLevelPageState();
}

class _PuzzleLevelPageState extends State<PuzzleLevelPage> {
  late final PuzzleController controller;
  late final int categoryId;
  static const String _needRefreshKey = 'puzzle_need_refresh';

  @override
  void initState() {
    super.initState();
    controller = Get.find<PuzzleController>();
    categoryId = Get.arguments as int;

    // Load levels saat pertama kali page dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadLevels(categoryId);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAndRefresh();
  }

  Future<void> _checkAndRefresh() async {
    final prefs = await SharedPreferences.getInstance();
    final needRefresh = prefs.getBool(_needRefreshKey) ?? false;

    if (needRefresh && mounted) {
      await prefs.setBool(_needRefreshKey, false);
      await controller.loadLevels(categoryId);
    }
  }

  // Manual refresh dengan pull-to-refresh
  Future<void> _onRefresh() async {
    await controller.loadLevels(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Pilih Level',
        showBackButton: true,
        height: 70,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.levels.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada level',
                    style: AppTextStyles.textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.white,
                ],
              ),
            ),
            child: GridView.builder(
              padding: AppSizes.paddingAllLg,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: controller.levels.length,
              itemBuilder: (context, index) {
                final level = controller.levels[index];
                final levelId = level['level_id'] as int? ?? 0;
                final levelNumber = level['level_number'] as int? ?? 0;
                final word = (level['word'] as String?) ?? '';
                final imageAsset = (level['image_asset'] as String?) ??
                    'assets/images/apel_level_img.png';
                final isUnlocked = level['is_unlocked'] == 1;
                final isCompleted = level['is_completed'] == 1;
                final stars = level['stars'] as int? ?? 0;

                return _LevelCard(
                  categoryId: categoryId,
                  levelNumber: levelNumber,
                  levelId: levelId,
                  word: word,
                  imageAsset: imageAsset,
                  isUnlocked: isUnlocked,
                  isCompleted: isCompleted,
                  stars: stars,
                  onTap: () async {
                    if (isUnlocked) {
                      await controller.startLevel(
                        levelId,
                        word,
                        imageAsset: imageAsset,
                      );

                      // Navigate biasa tanpa callback
                      Get.toNamed(AppConstants.puzzleRoute);
                    } else {
                      Get.snackbar(
                        'Level Terkunci 🔒',
                        'Selesaikan level sebelumnya untuk membuka level ini',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2),
                      );
                    }
                  },
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final int categoryId;
  final int levelNumber;
  final int levelId;
  final String word;
  final String imageAsset;
  final bool isUnlocked;
  final bool isCompleted;
  final int stars;
  final VoidCallback onTap;

  const _LevelCard({
    required this.categoryId,
    required this.levelNumber,
    required this.levelId,
    required this.word,
    required this.imageAsset,
    required this.isUnlocked,
    required this.isCompleted,
    required this.stars,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Generate hidden text dengan tanda bintang
    final hiddenWord = isUnlocked ? ('*' * word.length) : '???';
    final levelColor = _getLevelColor(categoryId, levelNumber);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // Background solid color dengan warna beragam (TANPA ubah warna jika completed)
          color: isUnlocked ? levelColor : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (isUnlocked ? levelColor : Colors.grey.shade400)
                  .withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Level number badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Level $levelNumber',
                      style: AppTextStyles.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Hidden text di bagian atas (ukuran lebih kecil)
                  Text(
                    hiddenWord,
                    style: AppTextStyles.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Image di tengah (tanpa background putih, transparan)
                  Expanded(
                    child: Center(
                      child: isUnlocked
                          ? Image.asset(
                              imageAsset,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image_not_supported,
                                  size: 60,
                                  color: Colors.white.withOpacity(0.5),
                                );
                              },
                            )
                          : Icon(
                              Icons.lock,
                              size: 60,
                              color: Colors.white.withOpacity(0.8),
                            ),
                    ),
                  ),
                  // HAPUS bagian stars - tidak ditampilkan lagi untuk completed level
                ],
              ),
            ),
            // Check icon overlay untuk completed
            if (isCompleted)
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.green.shade700,
                    size: 20,
                  ),
                ),
              ),
            // Lock icon overlay untuk locked
            if (!isUnlocked)
              Positioned(
                left: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.lock,
                    color: Colors.grey.shade700,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Generate warna untuk setiap level dengan urutan spesifik (berulang setiap 5 level)
  Color _getLevelColor(int categoryId, int levelNumber) {
    // 5 warna spesifik yang berulang sesuai urutan level
    final colors = [
      const Color(0xFFE39D96), // Level 1 - Pink Soft
      const Color(0xFFDDBF71), // Level 2 - Gold/Yellow
      const Color(0xFFD20A2E), // Level 3 - Red
      const Color(0xFFE1BD27), // Level 4 - Yellow/Gold
      const Color(0xFF2E2249), // Level 5 - Dark Purple
    ];

    // Level number 1-based, array 0-based
    return colors[(levelNumber - 1) % 5];
  }
}
