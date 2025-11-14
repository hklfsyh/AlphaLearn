import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class LetterOutlineComponent extends PositionComponent {
  String letter;
  late TextPainter _textPainter;

  LetterOutlineComponent({
    super.position,
    super.size,
    this.letter = 'A',
  }) : super() {
    _initTextPainter();
  }

  void _initTextPainter() {
    final textStyle = TextStyle(
      fontSize: size.y * 0.8,
      fontWeight: FontWeight.bold,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8.0
        ..color = const Color(0xFF111111).withOpacity(0.12),
      letterSpacing: 0,
    );

    _textPainter = TextPainter(
      text: TextSpan(text: letter, style: textStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    _textPainter.layout();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final offset = Offset(
      (size.x - _textPainter.width) / 2,
      (size.y - _textPainter.height) / 2,
    );

    _textPainter.paint(canvas, offset);
  }

  void updateLetter(String newLetter) {
    letter = newLetter;
    _initTextPainter();
  }
}
