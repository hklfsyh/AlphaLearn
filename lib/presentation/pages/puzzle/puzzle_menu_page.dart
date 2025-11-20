import 'package:alphalearn/core/core.dart';
import 'package:alphalearn/presentation/controller/puzzle/puzzle_controller.dart';
import 'package:alphalearn/presentation/widget/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PuzzleMenuPage extends StatelessWidget {
  const PuzzleMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PuzzleController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Kategori'),
        centerTitle: true,
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
              final description = category['description'] as String?;

              return FutureBuilder<bool>(
                future: controller.isCategoryLocked(categoryId),
                builder: (context, snapshot) {
                  final isLocked = snapshot.data ?? false;

                  return CardWidget(
                    title: categoryName,
                    subtitle: description,
                    imagePath: _getCategoryImage(categoryId),
                    backgroundColor: isLocked
                        ? Colors.grey.shade400
                        : _getCategoryColor(categoryId),
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
                    child: isLocked
                        ? Positioned(
                            right: 16,
                            bottom: 16,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          )
                        : null,
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }

  String _getCategoryImage(int categoryId) {
    switch (categoryId) {
      case 1: // Buah
        return 'assets/images/asset_monyet.png';
      case 2: // Binatang
        return 'assets/images/asset_monyet.png';
      case 3: // Tubuh
        return 'assets/images/asset_monyet.png';
      case 4: // Benda
        return 'assets/images/asset_monyet.png';
      case 5: // Keluarga
        return 'assets/images/asset_monyet.png';
      default:
        return 'assets/images/asset_monyet.png';
    }
  }

  Color _getCategoryColor(int categoryId) {
    switch (categoryId) {
      case 1: // Buah
        return const Color(0xFFFF6B6B); // Red
      case 2: // Binatang
        return const Color(0xFF4ECDC4); // Teal
      case 3: // Tubuh
        return const Color(0xFF95E1D3); // Light Green
      case 4: // Benda
        return const Color(0xFFFECA57); // Yellow
      case 5: // Keluarga
        return const Color(0xFFEE5A6F); // Pink
      default:
        return AppColors.primary;
    }
  }
}
