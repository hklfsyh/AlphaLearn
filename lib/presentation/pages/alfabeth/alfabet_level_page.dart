import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/core.dart';
import '../../controller/alfabeth/alfabeth_controller.dart';
import '../../widget/app_bar_custom.dart';

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

  // List untuk menyimpan jawaban yang akan ditampilkan (termasuk distractor)
  List<Map<String, dynamic>> answerOptions = [];

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    currentLevel = Get.arguments ?? 'A';
    controller = Get.find<AlfabetController>();
    _generateAnswerOptions();
  }

  // Generate jawaban benar + 3 distractor, lalu acak urutannya
  void _generateAnswerOptions() {
    final allLevels = ['a', 'b', 'c', 'd', 'e'];
    final currentLowerLevel = currentLevel.toLowerCase();

    // Hapus level saat ini dari daftar
    final otherLevels = allLevels.where((l) => l != currentLowerLevel).toList();

    // Buat list untuk menyimpan distractor yang sudah dipilih
    List<String> selectedDistractors = [];

    // Generate 3 distractor yang berbeda
    while (selectedDistractors.length < 3 && otherLevels.isNotEmpty) {
      final distractorLevel = otherLevels[_random.nextInt(otherLevels.length)];
      final distractorSide = _random.nextBool() ? '1' : '2';
      final distractorImage =
          'assets/images/${distractorLevel}filled$distractorSide.png';

      // Pastikan tidak ada duplikat
      if (!selectedDistractors.contains(distractorImage)) {
        selectedDistractors.add(distractorImage);
      }
    }

    // Buat list jawaban: 2 benar + 3 salah
    answerOptions = [
      {
        'type': 'left', // Jawaban benar kiri
        'image': 'assets/images/${currentLowerLevel}filled1.png',
        'isCorrect': true,
      },
      {
        'type': 'right', // Jawaban benar kanan
        'image': 'assets/images/${currentLowerLevel}filled2.png',
        'isCorrect': true,
      },
      {
        'type': 'distractor', // Jawaban pengecoh 1
        'image': selectedDistractors[0],
        'isCorrect': false,
      },
      {
        'type': 'distractor', // Jawaban pengecoh 2
        'image': selectedDistractors[1],
        'isCorrect': false,
      },
      {
        'type': 'distractor', // Jawaban pengecoh 3
        'image': selectedDistractors[2],
        'isCorrect': false,
      },
    ];

    // Acak urutan jawaban
    answerOptions.shuffle(_random);
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

  // Method untuk membangun setiap kotak jawaban
  Widget _buildAnswerBox(Map<String, dynamic> option, double answerSize) {
    final type = option['type'] as String;
    final image = option['image'] as String;

    // Cek apakah jawaban ini sudah diisi
    final isFilled =
        (type == 'left' && leftFilled) || (type == 'right' && rightFilled);

    // Jika sudah diisi, tampilkan icon centang
    if (isFilled) {
      return Container(
        width: answerSize,
        height: answerSize,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.check_circle,
          color: Colors.white,
          size: 40,
        ),
      );
    }

    // Tampilkan draggable (untuk jawaban benar atau distractor yang belum diisi)
    return Draggable<String>(
      data: type, // 'left', 'right', atau 'distractor'
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.7,
          child: Container(
            width: answerSize,
            height: answerSize,
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        width: answerSize,
        height: answerSize,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Container(
        width: answerSize,
        height: answerSize,
        child: Image.asset(
          image,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final questionSize = screenSize.width * 0.7;
    final answerSize = screenSize.width * 0.18; // Dikecilkan dari 0.25 ke 0.18

    return Scaffold(
      appBar: AppBarCustom(
        title: 'Level $currentLevel',
        showBackButton: true,
        height: 70,
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
            // Teks Perintah Soal - Di bawah AppBar (Style seperti game tebak huruf)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Text(
                'Pilih balok yang sesuai agar membentuk huruf ini',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Area Soal (Drop Target)
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
                                    onWillAcceptWithDetails: (details) {
                                      // Hanya terima jika data adalah 'left' dan belum diisi
                                      return details.data == 'left' &&
                                          !leftFilled;
                                    },
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
                                    onWillAcceptWithDetails: (details) {
                                      // Hanya terima jika data adalah 'right' dan belum diisi
                                      return details.data == 'right' &&
                                          !rightFilled;
                                    },
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
                                      onWillAcceptWithDetails: (details) {
                                        // Hanya terima jika data adalah 'left' dan belum diisi
                                        return details.data == 'left' &&
                                            !leftFilled;
                                      },
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
                                      onWillAcceptWithDetails: (details) {
                                        // Hanya terima jika data adalah 'right' dan belum diisi
                                        return details.data == 'right' &&
                                            !rightFilled;
                                      },
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

            const SizedBox(height: 20),

            // Area Jawaban (Draggable) dengan background hijau - DIPERBESAR dengan border radius
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
              decoration: BoxDecoration(
                color: Color(0xFF2A5731), // Hijau gelap
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Teks "Balok Tersedia"
                  Text(
                    'Balok Tersedia',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Grid Jawaban - 3 di atas, 2 di bawah
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Baris pertama: 3 kotak
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: answerOptions.take(3).map((option) {
                          return _buildAnswerBox(option, answerSize);
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      // Baris kedua: 2 kotak (center)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(width: answerSize), // Spacer kiri
                          ...answerOptions.skip(3).take(2).map((option) {
                            return _buildAnswerBox(option, answerSize);
                          }).toList(),
                          SizedBox(width: answerSize), // Spacer kanan
                        ],
                      ),
                    ],
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
