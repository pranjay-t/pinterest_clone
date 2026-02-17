import 'package:hive/hive.dart';

part 'pexels_media_model.g.dart';

@HiveType(typeId: 8)
class PexelsMedia {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int width;
  @HiveField(2)
  final int height;
  @HiveField(3)
  final String url;
  @HiveField(4)
  final String photographer;
  @HiveField(5)
  final String photographerUrl;
  @HiveField(6)
  final int photographerId;
  @HiveField(7)
  final String avgColor;

  PexelsMedia({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.photographer,
    required this.photographerUrl,
    required this.photographerId,
    required this.avgColor,
  });
}
