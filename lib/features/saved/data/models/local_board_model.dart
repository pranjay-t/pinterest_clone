import 'package:hive/hive.dart';

part 'local_board_model.g.dart';

@HiveType(typeId: 2)
class LocalBoardModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  String? coverImage;

  @HiveField(4)
  List<String> previewImages;

  @HiveField(5, defaultValue: 0)
  int pinCount;

  LocalBoardModel({
    required this.id,
    required this.name,
    required this.createdAt,
    this.coverImage,
    List<String>? previewImages,
    this.pinCount = 0,
  }) : previewImages = previewImages ?? [];
}
