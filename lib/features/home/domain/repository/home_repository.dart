import 'package:dartz/dartz.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart'; 
import 'package:pinterest_clone/features/home/data/models/pexels_video_model.dart';

abstract class HomeRepository {
  Future<Either<Exception, List<PexelsPhoto>>> fetchCuratedPhotos({
    required int page,
    int perPage = 15,
  });

  Future<Either<Exception, List<PexelsVideo>>> searchVideos({
    required String query,
    required int page,
    int perPage = 15,
  });

  Future<Either<Exception, List<PexelsVideo>>> fetchPopularVideos({
    required int page,
    int perPage = 15,
  });
}
