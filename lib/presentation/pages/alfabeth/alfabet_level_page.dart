import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/core.dart';
import '../../controller/alfabeth/alfabeth_controller.dart';

class AlfabetLevelPage extends StatefulWidget {
  const AlfabetLevelPage({super.key});

  @override
  State<AlfabetLevelPage> createState() => _AlfabetLevelPageState();
}

class _AlfabetLevelPageState extends State<AlfabetLevelPage> {
  // Ambil level dari arguments (A, B, C, D, E)
  late String currentLevel;
  late AlfabetController controller;

  // State untuk tracking drag and drop
  bool leftFilled = false;
  bool rightFilled = false;
  bool isCompleted = false;

  // State untuk tracking posisi drag
  Offset? leftAnswerPosition;
  Offset? rightAnswerPosition;

  @override
  void initState() {
    super.initState();
    currentLevel = Get.arguments ?? 'A';
    controller = Get.find<AlfabetController>();
  }

  String _getLeftAnswerImage() {
    final level = currentLevel.toLowerCase();
    return 'assets/images/${level}filled1.png';
  }

  String _getRightAnswerImage() {
    final level = currentLevel.toLowerCase();
    return 'assets/images/${level}filled2.png';
  }

  // Fungsi ketika drag selesai
  void _onLeftDropped() {
    setState(() {
      leftFilled = true;
      _checkCompletion();
    });
  }

  void _onRightDropped() {
    setState(() {
      rightFilled = true;
      _checkCompletion();
    });
  }

  // Cek apakah level selesai
  void _checkCompletion() {
    if (leftFilled && rightFilled && !isCompleted) {
      setState(() {
        isCompleted = true;
      });

      // Tampilkan dialog selesai
      Future.delayed(const Duration(milliseconds: 500), () {
        _showCompletionDialog();
      });
    }
  }

  // Dialog ketika level selesai
  void _showCompletionDialog() {
    // Save progress
    controller.completeLevel(currentLevel);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Column(
          children: [
            Icon(Icons.celebration, size: 64, color: Colors.amber),
            SizedBox(height: 16),
            Text(
              'Level Selesai! 🎉',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Text(
          'Selamat! Kamu telah menyelesaikan Level $currentLevel',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Get.back(); // Kembali ke menu level
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Kembali ke Menu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final questionSize = screenSize.width * 0.7;
    final answerSize = screenSize.width * 0.25;

    return Scaffold(
      appBar: AppBar(
        title: Text('Level $currentLevel'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Container(
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
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Instruksi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Seret potongan huruf ke tempatnya!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40), // Area Soal (Drop Target)
            Expanded(
              child: Center(
                child: Container(
                  width: questionSize,
                  height: questionSize,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drop target kiri
                      DragTarget<String>(
                        onAcceptWithDetails: (details) {
                          if (details.data == 'left' && !leftFilled) {
                            _onLeftDropped();
                          }
                        },
                        builder: (context, candidateData, rejectedData) {
                          return Container(
                            width: questionSize / 2,
                            height: questionSize,
                            child: ClipRect(
                              child: Align(
                                alignment: Alignment.centerRight,
                                widthFactor: 1.0,
                                child: leftFilled
                                    ? Image.asset(
                                        _getLeftAnswerImage(),
                                        width: questionSize,
                                        height: questionSize,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.asset(
                                        'assets/images/${currentLevel.toLowerCase()}rangka1.png',
                                        width: questionSize,
                                        height: questionSize,
                                        fit: BoxFit.contain,
                                      ),
                              ),
                            ),
                          );
                        },
                      ),

                      // Drop target kanan (tanpa space/gap)
                      DragTarget<String>(
                        onAcceptWithDetails: (details) {
                          if (details.data == 'right' && !rightFilled) {
                            _onRightDropped();
                          }
                        },
                        builder: (context, candidateData, rejectedData) {
                          return Container(
                            width: questionSize / 2,
                            height: questionSize,
                            child: ClipRect(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                widthFactor: 1.0,
                                child: rightFilled
                                    ? Image.asset(
                                        _getRightAnswerImage(),
                                        width: questionSize,
                                        height: questionSize,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.asset(
                                        'assets/images/${currentLevel.toLowerCase()}rangka2.png',
                                        width: questionSize,
                                        height: questionSize,
                                        fit: BoxFit.contain,
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Area Jawaban (Draggable)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Jawaban Kiri
                  if (!leftFilled)
                    Draggable<String>(
                      data: 'left',
                      feedback: Material(
                        color: Colors.transparent,
                        child: Opacity(
                          opacity: 0.7,
                          child: Container(
                            width: answerSize,
                            height: answerSize,
                            child: Image.asset(
                              _getLeftAnswerImage(),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      childWhenDragging: Container(
                        width: answerSize,
                        height: answerSize,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Container(
                        width: answerSize,
                        height: answerSize,
                        child: Image.asset(
                          _getLeftAnswerImage(),
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  else
                    Container(
                      width: answerSize,
                      height: answerSize,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green, width: 2),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 48,
                      ),
                    ),

                  // Jawaban Kanan
                  if (!rightFilled)
                    Draggable<String>(
                      data: 'right',
                      feedback: Material(
                        color: Colors.transparent,
                        child: Opacity(
                          opacity: 0.7,
                          child: Container(
                            width: answerSize,
                            height: answerSize,
                            child: Image.asset(
                              _getRightAnswerImage(),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      childWhenDragging: Container(
                        width: answerSize,
                        height: answerSize,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Container(
                        width: answerSize,
                        height: answerSize,
                        child: Image.asset(
                          _getRightAnswerImage(),
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  else
                    Container(
                      width: answerSize,
                      height: answerSize,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green, width: 2),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 48,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
