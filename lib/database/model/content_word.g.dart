// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentWord _$ContentWordFromJson(Map<String, dynamic> json) => ContentWord(
      wordId: (json['word_id'] as num).toInt(),
      categoryId: (json['category_id'] as num).toInt(),
      word: json['word'] as String,
      imageAsset: json['image_asset'] as String,
    );

Map<String, dynamic> _$ContentWordToJson(ContentWord instance) =>
    <String, dynamic>{
      'word_id': instance.wordId,
      'category_id': instance.categoryId,
      'word': instance.word,
      'image_asset': instance.imageAsset,
    };
