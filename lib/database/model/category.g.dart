// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      categoryId: (json['category_id'] as num).toInt(),
      name: json['name'] as String,
      isCategorizedLevel: json['is_categorized_level'] as bool,
      sequenceOrder: (json['sequence_order'] as num).toInt(),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'category_id': instance.categoryId,
      'name': instance.name,
      'is_categorized_level': instance.isCategorizedLevel,
      'sequence_order': instance.sequenceOrder,
    };
