import 'package:alphalearn/core/core.dart';
import 'package:alphalearn/presentation/controller/puzzle/puzzle_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/app_bar_custom.dart';

class PuzzleMenuPage extends StatelessWidget {
  const PuzzleMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PuzzleController>();

    return Scaffold(
      appBar: AppBarCustom(
        title: 'Pilih Kategori',
        showBackButton: true,
        height: 70,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.categories.isEmpty) {
          return const Center(
            child: Text('Tidak ada kategori tersedia'),
          );
        }

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
          child: GridView.builder(
            padding: AppSizes.paddingAllLg,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
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
            },
          ),
        );
      }),
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
    return Material(
      elevation: isLocked ? 2 : 6,
      borderRadius: AppSizes.borderRadiusMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSizes.borderRadiusMd,
        child: Container(
          decoration: BoxDecoration(
            color: isLocked
                ? Colors.grey.shade400
                : _getCategoryColor(categoryId).withOpacity(0.1),
            borderRadius: AppSizes.borderRadiusMd,
            border: Border.all(
              color: isLocked
                  ? Colors.grey.shade600
                  : _getCategoryColor(categoryId),
              width: 2,
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
                    // Icon
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isLocked
                              ? Colors.grey.shade300
                              : _getCategoryColor(categoryId).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Center(
                          child: ColorFiltered(
                            colorFilter: isLocked
                                ? const ColorFilter.mode(
                                    Colors.grey,
                                    BlendMode.saturation,
                                  )
                                : const ColorFilter.mode(
                                    Colors.transparent,
                                    BlendMode.multiply,
                                  ),
                            child: Image.asset(
                              _getCategoryImage(categoryId),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Title
                    Text(
                      categoryName,
                      style: AppTextStyles.textTheme.titleMedium?.copyWith(
                        color: isLocked
                            ? Colors.grey.shade700
                            : _getCategoryColor(categoryId),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Lock icon overlay
              if (isLocked)
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
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
