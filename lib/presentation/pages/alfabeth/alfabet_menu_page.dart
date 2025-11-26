import 'package:flutter/material.dart';
import 'package:alphalearn/core/core.dart';
import 'package:get/get.dart';
import '../../controller/alfabeth/alfabeth_controller.dart';

class AlphabetMenuPage extends StatelessWidget {
  const AlphabetMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AlfabetController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Huruf'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.levels.isEmpty) {
          return const Center(
            child: Text('Tidak ada level tersedia'),
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
              final letter = level['word'] as String;
              final isLocked = controller.isLetterLocked(wordId);
              final isCompleted = controller.isLetterLocked(wordId);

              return _LevelCard(
                letter: letter,
                isLocked: isLocked,
                isCompleted: isCompleted,
                onTap: () {
                  if (!isLocked) {
                    print('Navigating to AlphabetGamePage with wordId: $wordId'); // Debug
                    Get.toNamed(AppConstants.alfabethRoute, arguments: wordId);
                  } else {
                    Get.snackbar(
                      'Terkunci 🔒',
                      'Selesaikan huruf sebelumnya terlebih dahulu',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.orange,
                      colorText: Colors.white,
                    );
                  }
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
  final String letter;
  final bool isLocked;
  final bool isCompleted;
  final VoidCallback onTap;

  const _LevelCard({
    required this.letter,
    required this.isLocked,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: isCompleted ? 6 : 2,
      borderRadius: AppSizes.borderRadiusMd,
      color: isLocked
          ? Colors.grey.shade300
          : (isCompleted ? const Color(0xFF4CAF50) : AppColors.white),
      child: InkWell(
        borderRadius: AppSizes.borderRadiusMd,
        onTap: isLocked ? null : onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: AppSizes.borderRadiusMd,
            border: Border.all(
              color: isLocked ? Colors.grey : AppColors.primary,
              width: 2,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                letter,
                style: AppTextStyles.textTheme.displayLarge?.copyWith(
                  color: isLocked ? Colors.grey.shade600 : AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isLocked)
                Positioned(
                  bottom: 8,
                  child: Icon(
                    Icons.lock,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                ),
              if (isCompleted)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}