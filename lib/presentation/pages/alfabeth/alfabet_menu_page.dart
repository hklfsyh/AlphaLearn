import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/core.dart';
import '../../controller/alfabeth/alfabeth_controller.dart';

class AlfabetMenuPage extends StatelessWidget {
  const AlfabetMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(AlfabetController());

    // Data untuk 5 level alfabet
    final List<Map<String, dynamic>> alfabetLevels = [
      {
        'level': 'A',
        'title': 'Level A',
        'icon': 'assets/images/iconlevela.png',
        'color': const Color(0xFFFF6B6B),
        'isLocked': false,
      },
      {
        'level': 'B',
        'title': 'Level B',
        'icon': 'assets/images/iconlevelb.png',
        'color': const Color(0xFF4ECDC4),
        'isLocked': false, // Will be checked dynamically
      },
      {
        'level': 'C',
        'title': 'Level C',
        'icon': 'assets/images/iconlevelc.png',
        'color': const Color(0xFF95E1D3),
        'isLocked': false, // Will be checked dynamically
      },
      {
        'level': 'D',
        'title': 'Level D',
        'icon': 'assets/images/iconleveld.png',
        'color': const Color(0xFFFECA57),
        'isLocked': false, // Will be checked dynamically
      },
      {
        'level': 'E',
        'title': 'Level E',
        'icon': 'assets/images/iconlevele.png',
        'color': const Color(0xFFEE5A6F),
        'isLocked': false, // Will be checked dynamically
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Level Alfabet'),
        centerTitle: true,
      ),
      body: Container(
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
          itemCount: alfabetLevels.length,
          itemBuilder: (context, index) {
            final level = alfabetLevels[index];
            final levelName = level['level'] as String;

            return Obx(() {
              // Rebuild when completedLevels changes
              controller.completedLevels.length;

              return _AlfabetLevelCard(
                level: levelName,
                title: level['title'] as String,
                iconPath: level['icon'] as String,
                backgroundColor: level['color'] as Color,
                isLocked: controller.isLevelLocked(levelName),
                onTap: controller.isLevelLocked(levelName)
                    ? () {
                        Get.snackbar(
                          'Terkunci 🔒',
                          'Selesaikan level sebelumnya terlebih dahulu',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.orange,
                          colorText: Colors.white,
                        );
                      }
                    : () {
                        // Navigate to specific alfabet level
                        Get.toNamed(
                          AppConstants.alfabethLevelRoute,
                          arguments: levelName,
                        );
                      },
              );
            });
          },
        ),
      ),
    );
  }
}

class _AlfabetLevelCard extends StatelessWidget {
  final String level;
  final String title;
  final String iconPath;
  final Color backgroundColor;
  final bool isLocked;
  final VoidCallback onTap;

  const _AlfabetLevelCard({
    required this.level,
    required this.title,
    required this.iconPath,
    required this.backgroundColor,
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
                : backgroundColor.withOpacity(0.1),
            borderRadius: AppSizes.borderRadiusMd,
            border: Border.all(
              color: isLocked ? Colors.grey.shade600 : backgroundColor,
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
                              : backgroundColor.withOpacity(0.2),
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
                              iconPath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Title
                    Text(
                      title,
                      style: AppTextStyles.textTheme.titleMedium?.copyWith(
                        color:
                            isLocked ? Colors.grey.shade700 : backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    // Level badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isLocked ? Colors.grey.shade500 : backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        level,
                        style: AppTextStyles.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
}
