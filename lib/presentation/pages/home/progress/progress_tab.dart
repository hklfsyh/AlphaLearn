import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class ProgressTab extends StatelessWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.background,
      child: Text('Progress'),
    );
  }
}
