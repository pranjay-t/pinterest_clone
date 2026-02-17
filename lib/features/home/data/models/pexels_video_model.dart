import 'package:hive/hive.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_media_model.dart';

part 'pexels_video_model.g.dart';

class PexelsVideoResponse {
  final int page;
  final int perPage;
  final List<PexelsVideo> videos;
  final int totalResults;
  final String? nextPage;

  PexelsVideoResponse({
    required this.page,
    required this.perPage,
    required this.videos,
    required this.totalResults,
    this.nextPage,
  });

  factory PexelsVideoResponse.fromJson(Map<String, dynamic> json) {
    return PexelsVideoResponse(
      page: json['page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      videos: (json['videos'] as List)
          .map((e) => PexelsVideo.fromJson(e))
          .toList(),
      totalResults: json['total_results'] ?? 0,
      nextPage: json['next_page'],
    );
  }
}

@HiveType(typeId: 6)
class PexelsVideo extends PexelsMedia {
  @HiveField(8)
  final int duration;
  @HiveField(9)
  final String image;
  @HiveField(10)
  final List<PexelsVideoFile> videoFiles;
  @HiveField(11)
  final List<PexelsVideoPicture> videoPictures;

  PexelsVideo({
    required int id,
    required int width,
    required int height,
    required String url,
    required String photographer,
    required String photographerUrl,
    required int photographerId,
    required String? avgColor,
    required this.duration,
    required this.image,
    required this.videoFiles,
    required this.videoPictures,
  }) : super(
          id: id,
          width: width,
          height: height,
          url: url,
          photographer: photographer,
          photographerUrl: photographerUrl,
          photographerId: photographerId,
          avgColor: avgColor ?? '#000000',
        );

  factory PexelsVideo.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return PexelsVideo(
      id: json['id'],
      width: json['width'],
      height: json['height'],
      url: json['url'],
      photographer: user['name'],
      photographerUrl: user['url'],
      photographerId: user['id'],
      avgColor: null,
      duration: json['duration'],
      image: json['image'],
      videoFiles: (json['video_files'] as List)
          .map((e) => PexelsVideoFile.fromJson(e))
          .toList(),
      videoPictures: (json['video_pictures'] as List)
          .map((e) => PexelsVideoPicture.fromJson(e))
          .toList(),
    );
  }
}

@HiveType(typeId: 7)
class PexelsVideoFile {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String quality;
  @HiveField(2)
  final String fileType;
  @HiveField(3)
  final int width;
  @HiveField(4)
  final int height;
  @HiveField(5)
  final double fps;
  @HiveField(6)
  final String link;
  @HiveField(7)
  final int size;

  PexelsVideoFile({
    required this.id,
    required this.quality,
    required this.fileType,
    required this.width,
    required this.height,
    required this.fps,
    required this.link,
    required this.size,
  });

  factory PexelsVideoFile.fromJson(Map<String, dynamic> json) {
    return PexelsVideoFile(
      id: json['id'],
      quality: json['quality'],
      fileType: json['file_type'],
      width: json['width'],
      height: json['height'],
      fps: (json['fps'] as num).toDouble(),
      link: json['link'],
      size: json['size'],
    );
  }
}

@HiveType(typeId: 9)
class PexelsVideoPicture {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int nr;
  @HiveField(2)
  final String picture;

  PexelsVideoPicture({
    required this.id,
    required this.nr,
    required this.picture,
  });

  factory PexelsVideoPicture.fromJson(Map<String, dynamic> json) {
    return PexelsVideoPicture(
      id: json['id'],
      nr: json['nr'],
      picture: json['picture'],
    );
  }
}
