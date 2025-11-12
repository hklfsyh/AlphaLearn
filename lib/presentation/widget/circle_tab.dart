import 'package:flutter/material.dart';

class CircleTab extends StatelessWidget {
  final Color color;
  final String icon;
  final String label;
  final bool isCenter;
  final double size; // diameter

  const CircleTab({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
    this.isCenter = false,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    final double circleSize = isCenter ? size * 1.2 : size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: isCenter ? 10 : 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/$icon.png',
                    fit: BoxFit.contain,
                    width: size * 0.48,
                    height: size * 0.48),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isCenter ? size * 0.22 : size * 0.18,
                    color: isCenter ? Colors.white : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
