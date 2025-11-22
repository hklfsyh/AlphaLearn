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
      appBar: AppBar(
        title: const Text('Tebak Huruf'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            _showExitDialog(context, controller);
          },
        ),
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${controller.score.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
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
                _buildProgressBar(controller),

                const SizedBox(height: 24),

                // Instruction
                Text(
                  'Huruf apa yang hilang?',
                  style: AppTextStyles.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),

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
  Widget _buildProgressBar(PuzzleController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level Progress',
                style: AppTextStyles.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                controller.correctAnswer.value,
                style: AppTextStyles.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: controller.isAnswered.value ? 1.0 : 0.0,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                controller.isAnswered.value && controller.score.value > 0
                    ? Colors.green
                    : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                    isHidden ? '?' : letter,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: isHidden ? AppColors.primary : Colors.black87,
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
