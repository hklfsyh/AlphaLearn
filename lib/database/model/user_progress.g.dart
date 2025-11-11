// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProgress _$UserProgressFromJson(Map<String, dynamic> json) => UserProgress(
      progressId: (json['progress_id'] as num).toInt(),
      categoryId: (json['category_id'] as num).toInt(),
      currentScore: (json['current_score'] as num).toInt(),
      maxQuestions: (json['max_questions'] as num).toInt(),
      isCompleted: json['is_completed'] as bool,
    );

Map<String, dynamic> _$UserProgressToJson(UserProgress instance) =>
    <String, dynamic>{
      'progress_id': instance.progressId,
      'category_id': instance.categoryId,
      'current_score': instance.currentScore,
      'max_questions': instance.maxQuestions,
      'is_completed': instance.isCompleted,
    };
