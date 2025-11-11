import 'package:json_annotation/json_annotation.dart';

part 'content_word.g.dart';

@JsonSerializable(
  createFactory: true,
  createToJson: true,
  fieldRename: FieldRename.snake,
)
class ContentWord {
  // PRIMARY KEY
  @JsonKey(name: 'word_id')
  final int wordId;

  // FOREIGN KEY: Mengacu ke tabel Category
  @JsonKey(name: 'category_id')
  final int categoryId;

  final String word;

  @JsonKey(name: 'image_asset')
  final String imageAsset;

  ContentWord({
    required this.wordId,
    required this.categoryId,
    required this.word,
    required this.imageAsset,
  });

  factory ContentWord.fromJson(Map<String, dynamic> json) =>
      _$ContentWordFromJson(json);
  Map<String, dynamic> toJson() => _$ContentWordToJson(this);
}
