import 'package:alphalearn/core/core.dart';
import 'package:alphalearn/presentation/widget/card_widget.dart';
import 'package:flutter/material.dart';

class MenuTab extends StatelessWidget {
  const MenuTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/images/bg_home.png',
            width: double.infinity, height: double.infinity, fit: BoxFit.cover),
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 48.0,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
              ),
              CardWidget(
                width: 300,
                height: 300,
                title: "Belajar Alfabet",
                imagePath: 'assets/images/alfabeth.png',
                backgroundColor: AppColors.cream,
              ),
              CardWidget(
                width: 300,
                height: 300,
                title: "Tebak Huruf",
                imagePath: 'assets/images/tebakhuruf.png',
                backgroundColor: AppColors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
