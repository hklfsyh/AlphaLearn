// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_completion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityCompletion _$ActivityCompletionFromJson(Map<String, dynamic> json) =>
    ActivityCompletion(
      completionId: (json['completion_id'] as num).toInt(),
      wordId: (json['word_id'] as num).toInt(),
      modeId: (json['mode_id'] as num).toInt(),
      isCompleted: json['is_completed'] as bool,
    );

Map<String, dynamic> _$ActivityCompletionToJson(ActivityCompletion instance) =>
    <String, dynamic>{
      'completion_id': instance.completionId,
      'word_id': instance.wordId,
      'mode_id': instance.modeId,
      'is_completed': instance.isCompleted,
    };
