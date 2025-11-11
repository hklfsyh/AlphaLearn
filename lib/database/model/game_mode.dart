import 'package:json_annotation/json_annotation.dart';

part 'game_mode.g.dart';

@JsonSerializable(
  createFactory: true,
  createToJson: true,
  fieldRename: FieldRename.snake,
)
class GameMode {
  // PRIMARY KEY
  @JsonKey(name: 'mode_id')
  final int modeId;

  @JsonKey(name: 'mode_name')
  final String modeName;

  GameMode({
    required this.modeId,
    required this.modeName,
  });

  factory GameMode.fromJson(Map<String, dynamic> json) =>
      _$GameModeFromJson(json);
  Map<String, dynamic> toJson() => _$GameModeToJson(this);
}
