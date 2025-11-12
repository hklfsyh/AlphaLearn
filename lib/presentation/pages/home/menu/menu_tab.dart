import 'package:alphalearn/core/core.dart';
import 'package:flutter/material.dart';

class MenuTab extends StatelessWidget {
  const MenuTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.background,
      child: SafeArea(
          child: Center(
        child: Text(
          'Home',
          style: AppTextStyles.textTheme.displayLarge,
        ),
      )),
    );
  }
}
