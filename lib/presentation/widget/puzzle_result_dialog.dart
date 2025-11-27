import 'package:alphalearn/core/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PuzzleResultDialog extends StatefulWidget {
  final bool isCorrect;
  final String word;
  final VoidCallback onBack;
  final VoidCallback onRetry;

  const PuzzleResultDialog({
    super.key,
    required this.isCorrect,
    required this.word,
    required this.onBack,
    required this.onRetry,
  });

  @override
  State<PuzzleResultDialog> createState() => _PuzzleResultDialogState();

  static void show({
    required bool isCorrect,
    required String word,
    required VoidCallback onBack,
    required VoidCallback onRetry,
  }) {
    Get.dialog(
      PuzzleResultDialog(
        isCorrect: isCorrect,
        word: word,
        onBack: onBack,
        onRetry: onRetry,
      ),
      barrierDismissible: false,
    );
  }
}

class _PuzzleResultDialogState extends State<PuzzleResultDialog> {
  @override
  void initState() {
    super.initState();

    // Auto back setelah 2 detik jika jawaban benar
    if (widget.isCorrect) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          widget.onBack();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 16,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: widget.isCorrect ? AppColors.bgCorrect : AppColors.error,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isCorrect ? 'Selamat! 🎉' : 'Coba Lagi!',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.isCorrect
                            ? 'Kamu berhasil menebak kata "${widget.word}" dengan benar.'
                            : 'Yuk coba lagi untuk menebak kata "${widget.word}".',
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                              color: Colors.black.withOpacity(0.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Image.asset(
                  widget.isCorrect
                      ? 'assets/images/star_img.png'
                      : 'assets/images/puzzle_incorrect.png',
                  width: 100,
                  height: 100,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      widget.isCorrect ? Icons.star : Icons.refresh,
                      size: 80,
                      color: Colors.white,
                    );
                  },
                ),
              ],
            ),

            // Tombol Coba Lagi (hanya tampil jika salah)
            if (!widget.isCorrect) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: widget.onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'Coba Lagi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
