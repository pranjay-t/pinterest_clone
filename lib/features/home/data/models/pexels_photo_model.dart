import 'package:pinterest_clone/features/home/data/models/pexels_media_model.dart';

class PexelsResponse {
  final int page;
  final int perPage;
  final List<PexelsPhoto> photos;

  PexelsResponse({
    required this.page,
    required this.perPage,
    required this.photos,
  });

  factory PexelsResponse.fromJson(Map<String, dynamic> json) {
    return PexelsResponse(
      page: json['page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      photos: (json['photos'] as List)
          .map((e) => PexelsPhoto.fromJson(e))
          .toList(),
    );
  }
}

class PexelsPhoto extends PexelsMedia {
  final PexelsPhotoSrc src;
  final String alt;

  PexelsPhoto({
    required super.id,
    required super.width,
    required super.height,
    required super.url,
    required super.photographer,
    required super.photographerUrl,
    required super.photographerId,
    required super.avgColor,
    required this.src,
    required this.alt,
  });

  factory PexelsPhoto.fromJson(Map<String, dynamic> json) {
    return PexelsPhoto(
      id: json['id'],
      width: json['width'],
      height: json['height'],
      url: json['url'],
      photographer: json['photographer'],
      photographerUrl: json['photographer_url'],
      photographerId: json['photographer_id'],
      avgColor: json['avg_color'],
      src: PexelsPhotoSrc.fromJson(json['src']),
      alt: json['alt'],
    );
  }
}

class PexelsPhotoSrc {
  final String original;
  final String large2x;
  final String large;
  final String medium;
  final String small;
  final String portrait;
  final String landscape;
  final String tiny;

  PexelsPhotoSrc({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  factory PexelsPhotoSrc.fromJson(Map<String, dynamic> json) {
    return PexelsPhotoSrc(
      original: json['original'],
      large2x: json['large2x'],
      large: json['large'],
      medium: json['medium'],
      small: json['small'],
      portrait: json['portrait'],
      landscape: json['landscape'],
      tiny: json['tiny'],
    );
  }
}
