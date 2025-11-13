import 'dart:async';

import 'package:alphalearn/core/core.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 3000), () {
      Navigator.pushReplacementNamed(context, AppConstants.homeRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Image.asset('assets/images/doodle_fruit.png'),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset('assets/images/doodle_animal.png')),
        Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Image.asset('assets/images/doodle_furniture.png')),
        Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo_app.png',
                width: 500,
                height: 500,
              ),
              Column(
                children: [
                  Text(
                    AppConstants.appName,
                    style: TextStyle(
                        fontFamily: "fredoka",
                        fontWeight: FontWeight.w700,
                        fontSize: 48.0,
                        color: AppColors.greenDark),
                  ),
                  Text(
                    'Belajar alphabet \nlebih mudah & menyenangkan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "nunito",
                        fontWeight: FontWeight.w700,
                        fontSize: 24.0,
                        color: AppColors.greenDark),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    ));
  }
}
