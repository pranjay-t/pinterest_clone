import 'package:dartz/dartz.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';

abstract class SearchRepository {
  Future<Either<Exception, List<PexelsPhoto>>> fetchPhotos({
    required String query,
    required int page,
    int perPage = 20,
  });
}
