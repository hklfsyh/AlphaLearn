import 'package:json_annotation/json_annotation.dart';

part 'activity_completion.g.dart';

@JsonSerializable(
  createFactory: true,
  createToJson: true,
  fieldRename: FieldRename.snake,
)
class ActivityCompletion {
  // PRIMARY KEY
  @JsonKey(name: 'completion_id')
  final int completionId;

  // FOREIGN KEY: Mengacu ke ContentWord
  @JsonKey(name: 'word_id')
  final int wordId;

  // FOREIGN KEY: Mengacu ke GameMode
  @JsonKey(name: 'mode_id')
  final int modeId;

  // DB menggunakan INTEGER (0/1), Dart menggunakan bool
  @JsonKey(name: 'is_completed')
  final bool isCompleted;

  ActivityCompletion({
    required this.completionId,
    required this.wordId,
    required this.modeId,
    required this.isCompleted,
  });

  factory ActivityCompletion.fromJson(Map<String, dynamic> json) =>
      _$ActivityCompletionFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityCompletionToJson(this);
}
