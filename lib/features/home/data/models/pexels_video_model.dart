import 'package:pinterest_clone/features/home/data/models/pexels_media_model.dart';

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

class PexelsVideo extends PexelsMedia {
  final int duration;
  final String image;
  final List<PexelsVideoFile> videoFiles;
  final List<PexelsVideoPicture> videoPictures;

  PexelsVideo({
    required int id,
    required int width,
    required int height,
    required String url,
    required String photographerName,
    required String photographerProfileUrl,
    required int photographerIdVal,
    required String? avgColorVal,
    required this.duration,
    required this.image,
    required this.videoFiles,
    required this.videoPictures,
  }) : super(
          id: id,
          width: width,
          height: height,
          url: url,
          photographer: photographerName,
          photographerUrl: photographerProfileUrl,
          photographerId: photographerIdVal,
          avgColor: avgColorVal ?? '#000000',
        );

  factory PexelsVideo.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return PexelsVideo(
      id: json['id'],
      width: json['width'],
      height: json['height'],
      url: json['url'],
      photographerName: user['name'],
      photographerProfileUrl: user['url'],
      photographerIdVal: user['id'],
      avgColorVal: null, // Video object doesn't seem to have avg_color at root based on sample, sample has it null inside video object? Sample: "avg_color": null in the root.
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

class PexelsVideoFile {
  final int id;
  final String quality;
  final String fileType;
  final int width;
  final int height;
  final double fps;
  final String link;
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

class PexelsVideoPicture {
  final int id;
  final int nr;
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
