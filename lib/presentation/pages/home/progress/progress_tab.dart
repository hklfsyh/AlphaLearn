import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class ProgressTab extends StatelessWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'Buah',
        'imagePath': 'assets/images/buah.png',
        'progress': 1.0,
        'isLocked': false,
        'backgroundColor': const Color(0xFFE39D96),
        'progressBarColor': const Color(0xFFC7372F),
      },
      {
        'name': 'Binatang',
        'imagePath': 'assets/images/asset_monyet.png',
        'progress': 0.3,
        'isLocked': false,
        'backgroundColor': const Color(0xFF2E6F40).withOpacity(0.64),
        'progressBarColor': const Color(0xFF2A5731)
      },
      {
        'name': 'Tubuh',
        'imagePath': 'assets/images/tubuh.png',
        'progress': 0.0,
        'isLocked': true,
        'backgroundColor': const Color(0xFFDDBF71),
        'progressBarColor': const Color(0xFFC9AC61),
      },
      {
        'name': 'Furniture',
        'imagePath': 'assets/images/furniture.png',
        'progress': 0.0,
        'isLocked': true,
        'backgroundColor': const Color(0xFF724935).withOpacity(0.64),
        'progressBarColor': const Color(0xFF724935),
      },
      {
        'name': 'Keluarga',
        'imagePath': 'assets/images/keluarga.png',
        'progress': 0.0,
        'isLocked': true,
        'backgroundColor': const Color(0xFF44ED9B).withOpacity(0.64),
        'progressBarColor': const Color(0xFF44ED9B),
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Progres Kamu',
          style: TextStyle(color: Color(0xFF45513C), fontFamily: 'assets/fonts/nunito_bold.ttf', shadows: [
            Shadow(
              offset: Offset(0.5, 0.5),
              blurRadius: 2.0,
              color: Colors.grey,
            ),
          ]),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Padding(
        padding: AppSizes.paddingAllLg,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            childAspectRatio: 0.9, // Adjust aspect ratio for card height
            crossAxisSpacing: AppSizes.paddingLg,
            mainAxisSpacing: AppSizes.paddingLg,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _CategoryCard(
              name: category['name'] as String,
              imagePath: category['imagePath'] as String,
              progress: category['progress'] as double,
              isLocked: category['isLocked'] as bool,
              backgroundColor: category['backgroundColor'] as Color,
              progressBarColor: category['progressBarColor'] as Color,
            );
          },
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final double progress;
  final bool isLocked;
  final Color backgroundColor;
  final Color progressBarColor;

  const _CategoryCard({
    required this.name,
    required this.imagePath,
    required this.progress,
    required this.isLocked,
    required this.backgroundColor,
    required this.progressBarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isLocked ? Colors.black.withOpacity(0.8) : backgroundColor,
        borderRadius: AppSizes.borderRadiusMd,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
              color: Color.fromARGB(255, 240, 240, 240),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          if (!isLocked)
            Image.asset(
              imagePath,
              width: 124,
              height: 124,
              fit: BoxFit.cover,
            )
          else
            const Icon(
              Icons.lock,
              size: 56,
              color: Colors.white,
            ),
          const SizedBox(height: AppSizes.paddingSm),
          if (!isLocked)
            Column(
              children: [
                const SizedBox(height: AppSizes.paddingXs),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade300,
                  color: progressBarColor,
                ),
                Text(
                  '[${(progress * 100).toInt()}%]',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 223, 223, 223),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
