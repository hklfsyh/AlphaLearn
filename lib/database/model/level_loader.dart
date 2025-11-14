import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LevelData {
  final String id;
  final String letter;
  final double outlineWidth;
  final double outlineHeight;
  final List<BlockDef> blocks;

  LevelData({
    required this.id,
    required this.letter,
    required this.outlineWidth,
    required this.outlineHeight,
    required this.blocks,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    final blocksJson = (json['blocks'] as List).cast<Map<String, dynamic>>();
    return LevelData(
      id: json['id'] as String,
      letter: json['letter'] as String,
      outlineWidth: (json['outline']?['width'] ?? 360).toDouble(),
      outlineHeight: (json['outline']?['height'] ?? 560).toDouble(),
      blocks: blocksJson.map((b) => BlockDef.fromJson(b)).toList(),
    );
  }
}

class BlockDef {
  final String id;
  final double sizeW;
  final double sizeH;
  final double targetCenterX;
  final double targetCenterY;
  final double targetAngle;
  final double initialPosX;
  final double initialPosY;
  final String? letterSegment;
  final String? color;

  BlockDef({
    required this.id,
    required this.sizeW,
    required this.sizeH,
    required this.targetCenterX,
    required this.targetCenterY,
    required this.targetAngle,
    required this.initialPosX,
    required this.initialPosY,
    this.letterSegment,
    this.color,
  });

  factory BlockDef.fromJson(Map<String, dynamic> json) {
    final size = json['size'] as Map<String, dynamic>;
    final t = json['targetCenter'] as Map<String, dynamic>;
    final init = json['initialPosition'] as Map<String, dynamic>;
    return BlockDef(
      id: json['id'] as String,
      sizeW: (size['w'] as num).toDouble(),
      sizeH: (size['h'] as num).toDouble(),
      targetCenterX: (t['x'] as num).toDouble(),
      targetCenterY: (t['y'] as num).toDouble(),
      targetAngle: (json['targetAngle'] as num).toDouble(),
      initialPosX: (init['x'] as num).toDouble(),
      initialPosY: (init['y'] as num).toDouble(),
      letterSegment: json['letterSegment'] as String?,
      color: json['color'] as String?,
    );
  }
}

class LevelLoader {
  final Map<String, LevelData> levels = {};

  LevelLoader();

  static Future<LevelLoader> loadFromAsset(String assetPath) async {
    try {
      final raw = await rootBundle.loadString(assetPath);
      final decoded = jsonDecode(raw);

      final loader = LevelLoader();

      // Check if JSON is array or object with 'levels' key
      List<dynamic> items;
      if (decoded is List) {
        items = decoded;
      } else if (decoded is Map<String, dynamic> &&
          decoded.containsKey('levels')) {
        items = decoded['levels'] as List;
      } else {
        throw Exception(
            'Invalid JSON structure. Expected array or object with "levels" key');
      }

      // Parse each level
      for (final item in items) {
        if (item is! Map<String, dynamic>) {
          print('Warning: Skipping invalid level item: $item');
          continue;
        }

        final lvl = LevelData.fromJson(item);
        loader.levels[lvl.id] = lvl;
      }

      print('Successfully loaded ${loader.levels.length} levels');
      return loader;
    } catch (e) {
      print('Error loading levels from $assetPath: $e');
      rethrow;
    }
  }

  LevelData? getLevel(String id) => levels[id];
}
