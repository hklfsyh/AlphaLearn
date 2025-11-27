import 'package:alphalearn/presentation/widget/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/core.dart';
import '../../controller/puzzle/puzzle_controller.dart';

class PuzzleLevelPage extends StatelessWidget {
  const PuzzleLevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PuzzleController>();

    return Scaffold(
      appBar: AppBarCustom(),
      body: Obx(() {
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withOpacity(0.05),
                AppColors.white,
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: List.generate(controller.levels.length, (index) {
                  final level = controller.levels[index];
                  final wordId = level['word_id'] as int;
                  final word = level['word'] as String;
                  final levelNumber = index + 1;

                  return FutureBuilder<bool>(
                    future: controller.isLevelCompleted(wordId),
                    builder: (context, snapshot) {
                      final isCompleted = snapshot.data ?? false;

                      return _LevelCard(
                        levelNumber: levelNumber,
                        word: word,
                        isCompleted: isCompleted,
                        imgAsset: level['image_asset'] ??
                            'assets/images/apel_level_img.png',
                        onTap: () async {
                          await controller.startLevel(
                            wordId,
                            word,
                            imageAsset: level['image_asset'],
                          );
                          Get.toNamed(AppConstants.puzzleRoute);
                        },
                      );
                    },
                  );
                }),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final int levelNumber;
  final String word;
  final bool isCompleted;
  final String imgAsset;
  final VoidCallback onTap;

  const _LevelCard({
    required this.levelNumber,
    required this.word,
    required this.isCompleted,
    required this.onTap,
    required this.imgAsset,
  });

  @override
  Widget build(BuildContext context) {
    // Card lebih besar: 140 x 160
    return SizedBox(
      width: 200,
      height: 200,
      child: Material(
        elevation: isCompleted ? 8 : 4,
        borderRadius: BorderRadius.circular(20),
        shadowColor: isCompleted
            ? Colors.green.withOpacity(0.4)
            : AppColors.primary.withOpacity(0.3),
        color: isCompleted ? const Color(0xFF4CAF50) : AppColors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isCompleted ? Colors.green.shade700 : AppColors.primary,
                width: 2.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Word
                Text(
                  word,
                  style: AppTextStyles.textTheme.titleLarge?.copyWith(
                    color: isCompleted ? Colors.white : AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Image lebih besar
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imgAsset,
                    width: 90,
                    height: 90,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? Colors.white.withOpacity(0.2)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: isCompleted ? Colors.white70 : Colors.grey,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
