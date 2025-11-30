import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    super.initState();
    // Gunakan Get.find jika sudah ada, atau Get.put jika belum
    if (Get.isRegistered<AlfabetController>()) {
      controller = Get.find<AlfabetController>();
      // Refresh data saat kembali ke halaman
      controller.loadLevels();
    } else {
      controller = Get.put(AlfabetController());
    }
  }

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
          // Loading state
          if (controller.isLoading.value) {
            return _buildLoadingState();
          }

          // Empty state
          if (controller.levels.isEmpty) {
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
            Text('Memuat level...'),
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
                  'Belum ada level alfabet',
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
            children: List.generate(controller.levels.length, (index) {
              final level = controller.levels[index];

              // Null-safe access
              final levelName =
                  (level['word'] as String?) ?? 'Level ${index + 1}';
              final levelNumber =
                  (level['level_number'] as int?) ?? (index + 1);
              final isUnlocked =
                  level['is_unlocked'] == 1 || level['is_unlocked'] == true;
              final isCompleted =
                  level['is_completed'] == 1 || level['is_completed'] == true;

              // Define colors for each level
              const colors = [
                Color(0xFFFF6B6B), // A - Red
                Color(0xFF4ECDC4), // B - Teal
                Color(0xFF95E1D3), // C - Mint
                Color(0xFFFECA57), // D - Yellow
                Color(0xFFEE5A6F), // E - Pink
              ];

              // Define icon paths
              const iconPaths = [
                'assets/images/iconlevela.png',
                'assets/images/iconlevelb.png',
                'assets/images/iconlevelc.png',
                'assets/images/iconleveld.png',
                'assets/images/iconlevele.png',
              ];

              final colorIndex = (levelNumber - 1) % colors.length;
              final backgroundColor = colors[colorIndex];
              final iconPath = iconPaths[colorIndex];

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
                        Get.toNamed(
                          AppConstants.alfabethLevelRoute,
                          arguments: levelName,
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
                            child: _buildIcon(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Title
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              isLocked ? Colors.grey.shade700 : backgroundColor,
                          fontFamily: 'Fredoka',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      // Level badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isLocked ? Colors.grey.shade500 : backgroundColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          level,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Fredoka',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Status overlay (completed/locked)
                _buildStatusOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (isLocked) {
      // Tampilkan tanda tanya untuk level terkunci
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

    // Tampilkan gambar untuk level unlocked
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(
        Colors.transparent,
        BlendMode.multiply,
      ),
      child: Image.asset(
        iconPath,
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
              child: Text(
                level,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: backgroundColor,
                  fontFamily: 'Fredoka',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusOverlay() {
    // Completed overlay
    if (isCompleted && !isLocked) {
      return Positioned(
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
            size: 22,
          ),
        ),
      );
    }

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
}
