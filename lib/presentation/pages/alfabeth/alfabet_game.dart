import 'package:alphalearn/database/model/level_loader.dart';
import 'package:alphalearn/presentation/pages/alfabeth/component/block_component.dart';
import 'package:alphalearn/presentation/pages/alfabeth/component/letter_outline_component.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class AlphabetGame extends FlameGame {
  LetterOutlineComponent? outline; // Changed from late to nullable
  final List<BlockComponent> blocks = [];
  LevelLoader? _loader;
  String currentLevelId = 'A';
  RectangleComponent? _bottomArea;
  RectangleComponent? _background;
  late Vector2 screenSize;
  @override
  Future<void> onLoad() async {
    try {
      await super.onLoad();

      screenSize = size;

      _background = RectangleComponent(
        position: Vector2.zero(),
        size: screenSize,
        paint: Paint()..color = const Color(0xFFF7F7F7),
      );
      add(_background!);

      _loader =
          await LevelLoader.loadFromAsset('assets/json/level_alfabet.json');

      if (_loader == null) {
        throw Exception('Failed to load level data');
      }

      await loadLevel(currentLevelId);
    } catch (e) {
      print('Error in onLoad: $e');
      rethrow;
    }
  }

  Future<void> loadLevel(String id) async {
    try {
      for (final block in blocks) {
        block.removeFromParent();
      }
      blocks.clear();

      if (outline != null) {
        outline!.removeFromParent();
      }

      if (_bottomArea != null) {
        _bottomArea!.removeFromParent();
      }

      final outlineSize = Vector2(screenSize.x, screenSize.y * 0.7);
      outline = LetterOutlineComponent(
        position: Vector2(0, 0),
        size: outlineSize,
        letter: id,
      );
      add(outline!);

      _bottomArea = RectangleComponent(
        position: Vector2(0, screenSize.y * 0.7),
        size: Vector2(screenSize.x, screenSize.y * 0.3),
        paint: Paint()..color = const Color(0xFF18492B),
      );
      add(_bottomArea!);

      final lvl = _loader?.getLevel(id);
      if (lvl == null) {
        print('Warning: Level $id not found');
        return;
      }

      for (final b in lvl.blocks) {
        final blockSize = Vector2(
          b.sizeW * outlineSize.x,
          b.sizeH * outlineSize.y,
        );
        final targetCenter = Vector2(
          b.targetCenterX * outlineSize.x,
          b.targetCenterY * outlineSize.y,
        );
        final initialPos = Vector2(
          b.initialPosX * screenSize.x,
          b.initialPosY * screenSize.y,
        );

        final comp = BlockComponent(
          id: b.id,
          size: blockSize,
          position: initialPos,
          anchor: Anchor.center,
          targetCenter: targetCenter,
          targetAngle: b.targetAngle,
          letterSegment: b.letterSegment,
        );

        blocks.add(comp);
        add(comp);
      }
    } catch (e) {
      print('Error in loadLevel: $e');
      rethrow;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (blocks.isNotEmpty && blocks.every((b) => b.isSnapped)) {
      onAllBlocksSnapped();
    }
  }

  void onBlockSnapped(String id) {
    final allSnapped = blocks.every((b) => b.isSnapped);
    if (allSnapped) {
      onAllBlocksSnapped();
    }
  }

  void onAllBlocksSnapped() {
    if (!overlays.isActive('level_complete')) {
      overlays.add('level_complete');
    }
  }

  Future<void> changeLevel(String newId) async {
    overlays.remove('level_complete');
    currentLevelId = newId;
    await loadLevel(newId);
  }

  @override
  void onRemove() {
    for (final block in blocks) {
      block.removeFromParent();
    }
    blocks.clear();
    super.onRemove();
  }
}
