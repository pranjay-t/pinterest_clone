import 'package:dartz/dartz.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart'; // Ideally should be Entity, but Model is fine for now

abstract class HomeRepository {
  Future<Either<Exception, List<PexelsPhoto>>> fetchCuratedPhotos({
    required int page,
    int perPage = 15,
  });
}
