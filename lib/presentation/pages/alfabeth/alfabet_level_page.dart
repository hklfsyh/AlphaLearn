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
  bool hasStartedDragging = false; // Track apakah user sudah mulai drag

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
      hasStartedDragging = true; // User sudah mulai drag
      leftFilled = true;
      _checkCompletion();
    });
  }

  void _onRightDropped() {
    setState(() {
      hasStartedDragging = true; // User sudah mulai drag
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

      // Tampilkan notifikasi setelah gambar berganti (0.8 detik)
      Future.delayed(const Duration(milliseconds: 800), () {
        _showCompletionDialog();
      });

      // Auto redirect setelah notifikasi selesai (0.8s + 3s = 3.8s total)
      Future.delayed(const Duration(milliseconds: 3800), () {
        if (mounted) {
          Get.back(); // Kembali ke halaman pemilihan level
        }
      });
    }
  }

  // Dialog ketika level selesai
  void _showCompletionDialog() {
    // Save progress
    controller.completeLevel(currentLevel);

    // Tampilkan dialog biasa tanpa animasi
    showDialog(
      context: context,
      barrierDismissible: false, // Tidak bisa dismiss dengan tap di luar
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFC107),
                  Color(0xFFFFD54F),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Selamat',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Kamu berhasil bentuk huruf \'$currentLevel\'',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Mari lanjut ke huruf selanjutnya!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Image.asset(
                  'assets/images/bintangsukses.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        );
      },
    );

    // Tutup dialog setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pop(); // Tutup dialog
      }
    });
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
                child: SizedBox(
                  width: questionSize,
                  height: questionSize,
                  child: isCompleted
                      ? // Tampilkan gambar lengkap saat selesai - TETAP DI TENGAH
                      Image.asset(
                          'assets/images/${currentLevel.toLowerCase()}lengkap.png',
                          fit: BoxFit.contain,
                        )
                      : !hasStartedDragging
                          ? // Tampilkan rangka lengkap sebelum drag - TETAP DI TENGAH
                          Stack(
                              alignment: Alignment.center,
                              children: [
                                // Gambar rangka lengkap - PERBESAR UKURAN & POSISI TENGAH
                                SizedBox(
                                  width: questionSize,
                                  height: questionSize,
                                  child: Image.asset(
                                    'assets/images/rangkalengkap${currentLevel.toLowerCase()}.png',
                                    width: questionSize,
                                    height: questionSize,
                                    fit: BoxFit.contain,
                                  ),
                                ),

                                // Invisible drag target kiri
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  width: questionSize / 2,
                                  child: DragTarget<String>(
                                    onAcceptWithDetails: (details) {
                                      if (details.data == 'left' &&
                                          !leftFilled) {
                                        _onLeftDropped();
                                      }
                                    },
                                    builder:
                                        (context, candidateData, rejectedData) {
                                      return Container(
                                        color: Colors.transparent,
                                      );
                                    },
                                  ),
                                ),

                                // Invisible drag target kanan
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  width: questionSize / 2,
                                  child: DragTarget<String>(
                                    onAcceptWithDetails: (details) {
                                      if (details.data == 'right' &&
                                          !rightFilled) {
                                        _onRightDropped();
                                      }
                                    },
                                    builder:
                                        (context, candidateData, rejectedData) {
                                      return Container(
                                        color: Colors.transparent,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : // Tampilkan rangka terpisah setelah drag - GESER KE KANAN
                          Transform.translate(
                              offset: Offset(20, 0),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Sisi Kiri - DragTarget (posisi di kiri)
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    bottom: 0,
                                    width: questionSize / 2 + 10,
                                    child: DragTarget<String>(
                                      onAcceptWithDetails: (details) {
                                        if (details.data == 'left' &&
                                            !leftFilled) {
                                          _onLeftDropped();
                                        }
                                      },
                                      builder: (context, candidateData,
                                          rejectedData) {
                                        return Image.asset(
                                          leftFilled
                                              ? _getLeftAnswerImage()
                                              : 'assets/images/${currentLevel.toLowerCase()}rangka1.png',
                                          fit: BoxFit.contain,
                                        );
                                      },
                                    ),
                                  ),

                                  // Sisi Kanan - DragTarget (posisi di kanan)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    width: questionSize / 2 + 10,
                                    child: DragTarget<String>(
                                      onAcceptWithDetails: (details) {
                                        if (details.data == 'right' &&
                                            !rightFilled) {
                                          _onRightDropped();
                                        }
                                      },
                                      builder: (context, candidateData,
                                          rejectedData) {
                                        return Image.asset(
                                          rightFilled
                                              ? _getRightAnswerImage()
                                              : 'assets/images/${currentLevel.toLowerCase()}rangka2.png',
                                          fit: BoxFit.contain,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
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
