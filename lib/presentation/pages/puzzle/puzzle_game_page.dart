import 'package:alphalearn/presentation/widget/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/core.dart';
import '../../controller/puzzle/puzzle_controller.dart';

class PuzzleGamePage extends StatelessWidget {
  const PuzzleGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PuzzleController>();

    return Scaffold(
      appBar: AppBarCustom(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          width: double.infinity,
          height: double.infinity,
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
          child: SafeArea(
            child: Column(
              children: [
                // Progress indicator

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Text(
                    'Pilih Huruf Yang Benar!',
                    style: AppTextStyles.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                ),
                Image.asset(
                  controller.currentImage.value,
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: Colors.grey.shade400,
                    );
                  },
                ),

                // Instruction

                const SizedBox(height: 32),

                // Word display with hidden letter
                Expanded(
                  child: Center(
                    child: _buildWordDisplay(controller),
                  ),
                ),

                const SizedBox(height: 32),

                _buildAnswerOptions(controller),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Progress bar

  // Word display with one hidden letter
  Widget _buildWordDisplay(PuzzleController controller) {
    final word = controller.correctAnswer.value;
    final hiddenIndex = controller.hiddenLetterIndex.value;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            word.length,
            (index) {
              final isHidden = index == hiddenIndex;
              final letter = word[index];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 70,
                height: 90,
                decoration: BoxDecoration(
                  color: isHidden
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isHidden ? AppColors.primary : Colors.grey.shade300,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    isHidden ? '_' : letter,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'Fredoka',
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Answer options grid
  Widget _buildAnswerOptions(PuzzleController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: controller.answerOptions.length,
        itemBuilder: (context, index) {
          final option = controller.answerOptions[index];
          final isSelected = controller.selectedAnswer.value == option;
          final correctLetter = controller
              .correctAnswer.value[controller.hiddenLetterIndex.value];
          final isCorrect = option == correctLetter;

          Color backgroundColor = Colors.white;
          Color borderColor = AppColors.primary;
          Color textColor = AppColors.primary;

          if (controller.isAnswered.value && isSelected) {
            if (isCorrect) {
              backgroundColor = Colors.green.shade50;
              borderColor = Colors.green;
              textColor = Colors.green.shade700;
            } else {
              backgroundColor = Colors.red.shade50;
              borderColor = Colors.red;
              textColor = Colors.red.shade700;
            }
          }

          return Material(
            elevation: isSelected ? 8 : 2,
            borderRadius: BorderRadius.circular(20),
            color: backgroundColor,
            child: InkWell(
              onTap: controller.isAnswered.value
                  ? null
                  : () => controller.checkAnswer(option),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: borderColor,
                    width: isSelected ? 4 : 2,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        option,
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontFamily: 'Fredoka',
                        ),
                      ),
                      if (controller.isAnswered.value && isSelected) ...[
                        const SizedBox(height: 4),
                        Icon(
                          isCorrect ? Icons.check_circle : Icons.cancel,
                          color: isCorrect ? Colors.green : Colors.red,
                          size: 32,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Exit confirmation dialog
  void _showExitDialog(BuildContext context, PuzzleController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Keluar dari Game?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Progress kamu tidak akan disimpan jika keluar sekarang.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Back to level page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
