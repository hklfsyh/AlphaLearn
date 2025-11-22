import 'package:alphalearn/core/core.dart';
import 'package:alphalearn/presentation/widget/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuTab extends StatelessWidget {
  const MenuTab({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.60;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: ListView(
        padding: AppSizes.paddingAllLg.copyWith(
          top: AppSizes.paddingXl * 1.5,
          bottom: AppSizes.bottomNavHeight + AppSizes.paddingLg,
        ),
        children: [
          Center(
            child: CardWidget(
              onTap: () => Get.toNamed(AppConstants.alfabethRoute),
              width: cardWidth,
              height: cardWidth,
              title: "Belajar Alfabet",
              imagePath: 'assets/images/alfabeth.png',
              backgroundColor: AppColors.cream,
            ),
          ),
          SizedBox(height: AppSizes.paddingXl * 1.5),
          Center(
            child: CardWidget(
              onTap: () => Get.toNamed(AppConstants.puzzleMenuRoute),
              width: cardWidth,
              height: cardWidth,
              title: "Tebak Huruf",
              imagePath: 'assets/images/tebakhuruf.png',
              backgroundColor: AppColors.grey,
            ),
          ),
          SizedBox(height: AppSizes.paddingLg),
        ],
      ),
    );
  }
}
