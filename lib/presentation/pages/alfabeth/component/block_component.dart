import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart' hide Key;

// ignore: must_be_immutable
class BlockComponent extends PositionComponent
    with DragCallbacks, TapCallbacks {
  final String id;
  final Vector2 targetCenter;
  final double targetAngle;
  final String? letterSegment; // Bagian huruf untuk blok ini
  bool isSnapped = false;

  static const double posThreshold = 30.0;
  static const double angleThreshold = 0.5;

  Paint _paint = Paint()..color = const Color(0xFFF3D35A);
  late TextPainter _textPainter;

  BlockComponent({
    required this.id,
    required Vector2 size,
    required Vector2 position,
    Anchor anchor = Anchor.center,
    required this.targetCenter,
    this.targetAngle = 0.0,
    this.letterSegment,
  }) : super(size: size, position: position, anchor: anchor) {
    if (letterSegment != null) {
      _initTextPainter();
    }
  }

  void _initTextPainter() {
    final textStyle = TextStyle(
      fontSize: size.y * 0.9,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF111111),
      letterSpacing: 0,
    );

    _textPainter = TextPainter(
      text: TextSpan(text: letterSegment, style: textStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    _textPainter.layout();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (letterSegment != null) {
      // Clip canvas dengan bentuk rounded rectangle
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(12),
      );

      canvas.save();
      canvas.clipRRect(rrect);

      // Background
      canvas.drawRRect(rrect, _paint);

      // Draw huruf di dalam blok
      final offset = Offset(
        (size.x - _textPainter.width) / 2,
        (size.y - _textPainter.height) / 2,
      );
      _textPainter.paint(canvas, offset);

      canvas.restore();

      // Border
      final border = Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0x33000000)
        ..strokeWidth = 2;
      canvas.drawRRect(rrect, border);
    } else {
      // Blok polos tanpa huruf
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(12),
      );
      canvas.drawRRect(rrect, _paint);

      final border = Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0x33000000)
        ..strokeWidth = 2;
      canvas.drawRRect(rrect, border);
    }
  }

  // Normalize angle to be within -π to π range
  double _normalizeAngle(double angle) {
    while (angle > pi) angle -= 2 * pi;
    while (angle < -pi) angle += 2 * pi;
    return angle;
  }

  double _angleDifference(double angle1, double angle2) {
    double diff = _normalizeAngle(angle1 - angle2);
    return diff.abs();
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (isSnapped) return;
    angle = _normalizeAngle(angle + pi / 2);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (isSnapped) return;
    priority = 100;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (isSnapped) return;
    position.add(event.localDelta);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (isSnapped) return;

    final center = position.clone();
    final dist = center.distanceTo(targetCenter);
    final angleDiff = _angleDifference(angle, targetAngle);

    if (dist < posThreshold && angleDiff < angleThreshold) {
      add(
        MoveEffect.to(
          targetCenter,
          EffectController(duration: 0.25, curve: Curves.easeOut),
          onComplete: () {
            add(
              RotateEffect.to(
                targetAngle,
                EffectController(duration: 0.2, curve: Curves.easeOut),
                onComplete: () {
                  isSnapped = true;
                  priority = 0;
                },
              ),
            );
          },
        ),
      );
    } else {
      priority = 0;
    }
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    priority = 0;
  }
}
