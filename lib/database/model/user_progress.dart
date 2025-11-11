import 'package:json_annotation/json_annotation.dart';

part 'user_progress.g.dart';

@JsonSerializable(
  createFactory: true,
  createToJson: true,
  fieldRename: FieldRename.snake,
)
class UserProgress {
  // PRIMARY KEY
  @JsonKey(name: 'progress_id')
  final int progressId;

  // FOREIGN KEY: Mengacu ke tabel Category
  @JsonKey(name: 'category_id')
  final int categoryId;

  @JsonKey(name: 'current_score')
  final int currentScore;

  @JsonKey(name: 'max_questions')
  final int maxQuestions;

  // DB menggunakan INTEGER (0/1), Dart menggunakan bool
  @JsonKey(name: 'is_completed')
  final bool isCompleted;

  UserProgress({
    required this.progressId,
    required this.categoryId,
    required this.currentScore,
    required this.maxQuestions,
    required this.isCompleted,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) =>
      _$UserProgressFromJson(json);
  Map<String, dynamic> toJson() => _$UserProgressToJson(this);
}
