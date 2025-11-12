import '../../../../core/core.dart';
import 'package:flutter/material.dart';

class AboutTab extends StatelessWidget {
  const AboutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.background,
      child: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 10,
              child: Image.asset(
                'assets/images/asset_monyet.png',
                width: 296,
                height: 296,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/logo_app.png',
                      width: 310,
                      height: 310,
                    ),
                    Text(
                      AppConstants.appName,
                      style: AppTextStyles.textTheme.displayLarge,
                    )
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Alphalearn merupakan aplikasi untuk meningkatkan minat anak dengan usia 0-5 tahun terhadap pengenalan huruf.',
                        style: AppTextStyles.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Digunakan untuk lomba Indoneris 2025 Mobile Programming Competition',
                        style: AppTextStyles.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
