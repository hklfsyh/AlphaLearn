import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/core.dart';
import '../../controller/alfabeth/alfabeth_controller.dart';
import '../../widget/app_bar_custom.dart';

class AlfabetMenuPage extends StatefulWidget {
  const AlfabetMenuPage({super.key});

  @override
  State<AlfabetMenuPage> createState() => _AlfabetMenuPageState();
}

class _AlfabetMenuPageState extends State<AlfabetMenuPage> {
  late final AlfabetController controller;
  static const String _needRefreshKey = 'alfabet_need_refresh';

  @override
  void initState() {
    super.initState();
    controller = Get.put(AlfabetController());

    // Load levels saat pertama kali page dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadLevels();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAndRefresh();
  }

  Future<void> _checkAndRefresh() async {
    final prefs = await SharedPreferences.getInstance();
    final needRefresh = prefs.getBool(_needRefreshKey) ?? false;

    if (needRefresh && mounted) {
      await prefs.setBool(_needRefreshKey, false);
      await controller.loadLevels();
    }
  }

  // Manual refresh dengan pull-to-refresh
  Future<void> _onRefresh() async {
    await controller.loadLevels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Pilih Level Alfabet',
        showBackButton: true,
        height: 70,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.levels.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada level alfabet',
                    style: AppTextStyles.textTheme.titleMedium,
                  ),
                ],
              ),
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
              itemCount: controller.levels.length,
              itemBuilder: (context, index) {
                final level = controller.levels[index];
                final levelName = level['word'] as String;
                final levelNumber = level['level_number'] as int;
                final isUnlocked = level['is_unlocked'] == 1;
                final isCompleted = level['is_completed'] == 1;

                // Define colors for each level
                final colors = [
                  const Color(0xFFFF6B6B), // A - Red
                  const Color(0xFF4ECDC4), // B - Teal
                  const Color(0xFF95E1D3), // C - Mint
                  const Color(0xFFFECA57), // D - Yellow
                  const Color(0xFFEE5A6F), // E - Pink
                ];

                // Define icon paths
                final iconPaths = [
                  'assets/images/iconlevela.png',
                  'assets/images/iconlevelb.png',
                  'assets/images/iconlevelc.png',
                  'assets/images/iconleveld.png',
                  'assets/images/iconlevele.png',
                ];

                final backgroundColor =
                    colors[(levelNumber - 1) % colors.length];
                final iconPath =
                    iconPaths[(levelNumber - 1) % iconPaths.length];

                return _AlfabetLevelCard(
                  level: levelName,
                  title: 'Level $levelName',
                  iconPath: iconPath,
                  backgroundColor: backgroundColor,
                  isLocked: !isUnlocked,
                  isCompleted: isCompleted,
                  onTap: !isUnlocked
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
                          // Navigate biasa tanpa callback
                          Get.toNamed(
                            AppConstants.alfabethLevelRoute,
                            arguments: levelName,
                          );
                        },
                );
              },
            ),
          );
        }),
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
  final bool isCompleted;
  final VoidCallback onTap;

  const _AlfabetLevelCard({
    required this.level,
    required this.title,
    required this.iconPath,
    required this.backgroundColor,
    required this.isLocked,
    required this.isCompleted,
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
              // Check icon overlay untuk completed
              if (isCompleted && !isLocked)
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.green.shade700,
                      size: 20,
                    ),
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
