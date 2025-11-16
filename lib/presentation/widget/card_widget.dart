import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String imagePath;
  final double? width, height;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Widget? child;
  final String? subtitle;

  const CardWidget(
      {super.key,
      required this.title,
      required this.imagePath,
      this.onTap,
      this.height,
      this.width,
      this.subtitle,
      this.backgroundColor,
      this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Card(
        elevation: 12,
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                            fontFamily: "fredoka",
                            fontWeight: FontWeight.w700,
                            fontSize: 24.0,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                  if (child != null) child!,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
