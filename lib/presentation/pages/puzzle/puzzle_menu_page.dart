import 'package:alphalearn/core/core.dart';
import 'package:alphalearn/presentation/controller/puzzle/puzzle_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/app_bar_custom.dart';

class PuzzleMenuPage extends StatefulWidget {
  const PuzzleMenuPage({super.key});

  @override
  State<PuzzleMenuPage> createState() => _PuzzleMenuPageState();
}

class _PuzzleMenuPageState extends State<PuzzleMenuPage> {
  late final PuzzleController controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<PuzzleController>()) {
      controller = Get.find<PuzzleController>();
      controller.loadCategories();
    } else {
      controller = Get.put(PuzzleController());
    }
  }

  Future<void> _onRefresh() async {
    await controller.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Pilih Kategori',
        showBackButton: true,
        height: 70,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        child: Obx(() {
          // Loading state
          if (controller.isLoading.value) {
            return _buildLoadingState();
          }

          // Empty state
          if (controller.categories.isEmpty) {
            return _buildEmptyState(context);
          }

          // Success state
          return _buildSuccessState();
        }),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
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
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Memuat kategori...'),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
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
      child: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Tidak ada kategori tersedia',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Tarik ke bawah untuk refresh',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Container(
      height: double.infinity,
      width: double.infinity,
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
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: List.generate(controller.categories.length, (index) {
              final category = controller.categories[index];
              final categoryId = category['category_id'] as int;
              final categoryName = category['name'] as String;

              return FutureBuilder<bool>(
                future: controller.isCategoryLocked(categoryId),
                builder: (context, snapshot) {
                  final isLocked = snapshot.data ?? false;

                  return _CategoryCard(
                    categoryId: categoryId,
                    categoryName: categoryName,
                    isLocked: isLocked,
                    onTap: isLocked
                        ? () {
                            Get.snackbar(
                              'Terkunci 🔒',
                              'Selesaikan kategori sebelumnya terlebih dahulu',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.orange,
                              colorText: Colors.white,
                            );
                          }
                        : () async {
                            await controller.loadLevels(categoryId);
                            Get.toNamed(
                              AppConstants.puzzleLevelRoute,
                              arguments: categoryId,
                            );
                          },
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final int categoryId;
  final String categoryName;
  final bool isLocked;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.categoryId,
    required this.categoryName,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getCategoryColor(categoryId);

    return SizedBox(
      width: 160,
      height: 200,
      child: Material(
        elevation: isLocked ? 2 : 6,
        borderRadius: BorderRadius.circular(20),
        shadowColor: isLocked
            ? Colors.grey.withOpacity(0.3)
            : backgroundColor.withOpacity(0.4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: isLocked
                  ? Colors.grey.shade400
                  : backgroundColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isLocked ? Colors.grey.shade600 : backgroundColor,
                width: 2.5,
              ),
            ),
            child: Stack(
              children: [
                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon container
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isLocked
                                ? Colors.grey.shade300
                                : backgroundColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: _buildIcon(backgroundColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Title
                      Text(
                        categoryName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              isLocked ? Colors.grey.shade700 : backgroundColor,
                          fontFamily: 'Fredoka',
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Status overlay (locked)
                _buildStatusOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(Color backgroundColor) {
    if (isLocked) {
      // Tampilkan tanda tanya untuk category terkunci
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade500,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text(
            '?',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Fredoka',
            ),
          ),
        ),
      );
    }

    // Tampilkan gambar untuk category unlocked
    return Image.asset(
      _getCategoryImage(categoryId),
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              _getCategoryIcon(categoryId),
              size: 32,
              color: backgroundColor,
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusOverlay() {
    // Locked overlay
    if (isLocked) {
      return Positioned(
        right: 12,
        top: 12,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock,
            color: Colors.white,
            size: 20,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  String _getCategoryImage(int categoryId) {
    switch (categoryId) {
      case 1: // Buah
        return 'assets/images/buah.png';
      case 2: // Binatang
        return 'assets/images/monyet.png';
      case 3: // Tubuh
        return 'assets/images/tubuh.png';
      case 4: // Benda
        return 'assets/images/furniture.png';
      case 5: // Keluarga
        return 'assets/images/keluarga.png';
      default:
        return 'assets/images/doodle_animal.png';
    }
  }

  IconData _getCategoryIcon(int categoryId) {
    switch (categoryId) {
      case 1:
        return Icons.apple;
      case 2:
        return Icons.pets;
      case 3:
        return Icons.accessibility_new;
      case 4:
        return Icons.chair;
      case 5:
        return Icons.family_restroom;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(int categoryId) {
    switch (categoryId) {
      case 1: // Buah
        return const Color(0xFFE39D96);
      case 2: // Binatang
        return const Color(0xFF2E6F40);
      case 3: // Tubuh
        return const Color(0xFFDDBF71);
      case 4: // Benda
        return const Color(0xFF724935);
      case 5: // Keluarga
        return const Color(0xFF44ED9B);
      default:
        return AppColors.primary;
    }
  }
}
