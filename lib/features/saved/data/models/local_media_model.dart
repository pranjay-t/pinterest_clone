import 'package:hive/hive.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_video_model.dart';

part 'local_media_model.g.dart';

@HiveType(typeId: 0)
enum MediaType {
  @HiveField(0)
  photo,
  @HiveField(1)
  video,
}

@HiveType(typeId: 1)
class LocalMediaModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final MediaType type;

  @HiveField(3)
  final int width;

  @HiveField(4)
  final int height;

  @HiveField(5)
  final String? title;

  @HiveField(6)
  final String? description;

  @HiveField(7)
  final String? photographer;

  @HiveField(8)
  final String? photographerUrl;

  @HiveField(9)
  final DateTime savedAt;

  @HiveField(10)
  List<String> boardIds;

  @HiveField(11)
  final String? videoUrl;

  @HiveField(12)
  final int? duration;

  @HiveField(13)
  final PexelsPhoto? pexelsPhoto;

  @HiveField(14)
  final PexelsVideo? pexelsVideo;

  LocalMediaModel({
    required this.id,
    required this.url,
    required this.type,
    required this.width,
    required this.height,
    this.title,
    this.description,
    this.photographer,
    this.photographerUrl,
    required this.savedAt,
    List<String>? boardIds,
    this.videoUrl,
    this.duration,
    this.pexelsPhoto,
    this.pexelsVideo,
  }) : boardIds = boardIds ?? [];
}
