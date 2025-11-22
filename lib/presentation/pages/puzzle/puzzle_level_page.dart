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
      appBar: AppBar(
        title: Obx(() {
          final category = controller.categories.firstWhereOrNull(
            (cat) => cat['category_id'] == controller.currentCategoryId.value,
          );
          return Text(category?['name'] ?? 'Pilih Level');
        }),
        centerTitle: true,
      ),
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
          child: GridView.builder(
            padding: AppSizes.paddingAllLg,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: controller.levels.length,
            itemBuilder: (context, index) {
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
                    onTap: () async {
                      await controller.startLevel(wordId, word);
                      Get.toNamed(AppConstants.puzzleRoute);
                    },
                  );
                },
              );
            },
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
  final VoidCallback onTap;

  const _LevelCard({
    required this.levelNumber,
    required this.word,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: isCompleted ? 6 : 2,
      borderRadius: AppSizes.borderRadiusMd,
      color: isCompleted ? const Color(0xFF4CAF50) : AppColors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSizes.borderRadiusMd,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppSizes.borderRadiusMd,
            border: Border.all(
              color: isCompleted ? Colors.green.shade700 : AppColors.primary,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Level number badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.white.withOpacity(0.3)
                      : AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Level $levelNumber',
                  style: AppTextStyles.textTheme.labelSmall?.copyWith(
                    color: isCompleted ? Colors.white : AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Word
              Text(
                word,
                style: AppTextStyles.textTheme.titleLarge?.copyWith(
                  color: isCompleted ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Status icon
              Icon(
                isCompleted ? Icons.check_circle : Icons.play_circle_outline,
                color: isCompleted ? Colors.white : AppColors.primary,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
