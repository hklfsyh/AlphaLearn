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
      appBar: AppBarCustom(
        title: 'Tebak Huruf',
        showBackButton: true,
        height: 70,
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
          color: Colors.white, // Background putih
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Dikurangi dari 20 ke 16
                child: Column(
                  children: [
                    // Progress indicator
                    _buildProgressIndicator(controller),

                    const SizedBox(height: 16), // Dikurangi dari 20 ke 16

                    // Instruksi - tebal hitam seperti alfabet
                    Text(
                      'Tebak Huruf Yang Hilang!',
                      style: AppTextStyles.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Fredoka',
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20), // Dikurangi dari 24 ke 20

                    // Gambar besar di tengah - tanpa background
                    Image.asset(
                      controller.currentImage.value,
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported,
                          size: 120,
                          color: Colors.grey.shade400,
                        );
                      },
                    ),

                    const SizedBox(height: 24), // Dikurangi dari 32 ke 24

                    // Grid jawaban (kata dengan huruf tersembunyi)
                    _buildWordDisplay(controller),

                    const SizedBox(height: 24), // Dikurangi dari 32 ke 24

                    // Grid pilihan huruf
                    _buildAnswerOptions(controller),

                    const SizedBox(height: 16), // Dikurangi dari 20 ke 16
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // Progress indicator - hanya teks
  Widget _buildProgressIndicator(PuzzleController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.stars, color: AppColors.warning, size: 24),
        const SizedBox(width: 8),
        Text(
          'Progress: ${controller.score.value}/${controller.totalQuestions.value}',
          style: AppTextStyles.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontFamily: 'Fredoka',
          ),
        ),
      ],
    );
  }

  // Word display with one hidden letter - Grid soal (persegi, ukuran dikecilkan)
  Widget _buildWordDisplay(PuzzleController controller) {
    final word = controller.correctAnswer.value;
    final hiddenIndex = controller.hiddenLetterIndex.value;
    final completedIndexes = controller.completedLetterIndexes;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        word.length,
        (index) {
          final isHidden =
              index == hiddenIndex && !completedIndexes.contains(index);
          final isCompleted = completedIndexes.contains(index);
          final letter = word[index];

          return Container(
            width: 50, // Dikecilkan dan dibuat persegi
            height: 50, // Sama dengan width (persegi)
            decoration: BoxDecoration(
              color: const Color(0xFF2A5731), // Hijau tua untuk semua grid soal
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCompleted
                    ? AppColors.success
                    : isHidden
                        ? const Color(0xFF2A5731)
                        : const Color(0xFF2A5731),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                isHidden && !isCompleted
                    ? '_'
                    : letter, // Gunakan "_" bukan "?"
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Teks putih untuk semua
                  fontFamily: 'Fredoka',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Answer options grid - Grid jawaban (warna hijau, ukuran sama dengan grid soal: 50x50)
  Widget _buildAnswerOptions(PuzzleController controller) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        controller.answerOptions.length,
        (index) {
          final option = controller.answerOptions[index];
          final isSelected = controller.selectedAnswer.value == option;
          final correctLetter = controller
              .correctAnswer.value[controller.hiddenLetterIndex.value];
          final isCorrect = option == correctLetter;

          Color backgroundColor =
              const Color(0xFF2A5731); // Hijau sama dengan grid soal
          Color borderColor = const Color(0xFF2A5731);
          Color textColor = Colors.white;

          if (controller.isAnswered.value && isSelected) {
            if (isCorrect) {
              backgroundColor = AppColors.success;
              borderColor = AppColors.success;
              textColor = Colors.white;
            } else {
              backgroundColor = AppColors.error;
              borderColor = AppColors.error;
              textColor = Colors.white;
            }
          }

          return Material(
            elevation: isSelected ? 4 : 1,
            borderRadius: BorderRadius.circular(12),
            color: backgroundColor,
            child: InkWell(
              onTap: controller.isAnswered.value
                  ? null
                  : () => controller.checkAnswer(option),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 50, // Sama dengan grid soal
                height: 50, // Sama dengan grid soal (persegi)
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 28, // Sama dengan grid soal
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Fredoka',
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
