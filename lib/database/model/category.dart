import 'package:json_annotation/json_annotation.dart';

// Baris ini memberi tahu Dart untuk mengambil kode yang di-generate dari file category.g.dart
// PENTING: File ini harus Anda buat secara manual.
part 'category.g.dart';

@JsonSerializable(
  // Pilihan ini memastikan class dapat bekerja dengan Map<String, dynamic> dari sqflite
  createFactory: true,
  createToJson: true,
  fieldRename: FieldRename
      .snake, // Opsional: Mengubah Dart camelCase menjadi snake_case DB.
)
class Category {
  // Catatan: is_categorized_level di DB adalah INTEGER (0/1),
  // tetapi di Dart kita konversi menjadi boolean agar lebih mudah digunakan.

  // PRIMARY KEY
  @JsonKey(name: 'category_id')
  final int categoryId;

  final String name;

  // Karena DB menggunakan INTEGER (0/1), kita harus menggunakan converter.
  // Tapi untuk sqflite, kita bisa membaca langsung int 0/1 sebagai bool.
  @JsonKey(name: 'is_categorized_level')
  final bool isCategorizedLevel;

  @JsonKey(name: 'sequence_order')
  final int sequenceOrder;

  // Constructor
  Category({
    required this.categoryId,
    required this.name,
    required this.isCategorizedLevel,
    required this.sequenceOrder,
  });

  // Factory constructor untuk membaca dari Map (misalnya, hasil query dari DB)
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  // Metode untuk menulis ke Map (untuk INSERT/UPDATE DB)
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  // Optional: Override toString() untuk debugging
  @override
  String toString() {
    return 'Category(id: $categoryId, name: $name, is_categorized: $isCategorizedLevel, sequence: $sequenceOrder)';
  }
}
