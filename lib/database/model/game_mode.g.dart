// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_mode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameMode _$GameModeFromJson(Map<String, dynamic> json) => GameMode(
      modeId: (json['mode_id'] as num).toInt(),
      modeName: json['mode_name'] as String,
    );

Map<String, dynamic> _$GameModeToJson(GameMode instance) => <String, dynamic>{
      'mode_id': instance.modeId,
      'mode_name': instance.modeName,
    };
