import 'package:flame/game.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'component/letter_outline_component.dart';
import 'component/block_component.dart';

class AlphabetGame extends FlameGame {
  final int wordId;

  AlphabetGame({required this.wordId});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Load game assets and initialize the game based on the wordId
    print('Loading game for wordId: $wordId');
    
    // Add your game logic here

    // Load level data from JSON
    final levelData = await _loadLevelData(wordId);

    final outlineData = levelData['outline'];
    add(
      LetterOutlineComponent(
        position: Vector2(size.x / 2 - outlineData['width'] / 2, size.y * 0.2),
        size: Vector2(outlineData['width'].toDouble(), outlineData['height'].toDouble()),
        letter: levelData['letter'],
      ),
    );

    // Add bottom slider
    final sliderHeight = size.y * 0.2;
    final slider = PositionComponent(
      position: Vector2(0, size.y - sliderHeight),
      size: Vector2(size.x, sliderHeight),
    );
    add(slider);

    // Add blocks
    final blocksData = levelData['blocks'] as List<dynamic>;
    for (final blockData in blocksData) {
      add(
        BlockComponent(
          id: blockData['id'],
          size: Vector2(
            blockData['size']['w'] * size.x,
            blockData['size']['h'] * size.y,
          ),
          position: Vector2(
            blockData['initialPosition']['x'] * size.x,
            blockData['initialPosition']['y'] * size.y,
          ),
          targetCenter: Vector2(
            blockData['targetCenter']['x'] * size.x,
            blockData['targetCenter']['y'] * size.y,
          ),
          targetAngle: blockData['targetAngle'],
        ),
      );
    }
  }
  
  Future<Map<String, dynamic>> _loadLevelData(int wordId) async {
    final jsonString = await rootBundle.loadString('assets/json/level_alfabet.json');
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final levels = jsonData['levels'] as List<dynamic>;
    return levels.firstWhere((level) => level['id'] == String.fromCharCode(wordId));
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update game state
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Render game elements
  }
}