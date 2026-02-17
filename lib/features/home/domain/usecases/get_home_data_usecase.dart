import 'dart:math';
import 'package:dartz/dartz.dart';
import 'package:pinterest_clone/core/usecase/usecase.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_media_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_video_model.dart';
import 'package:pinterest_clone/features/home/domain/repository/home_repository.dart';

class GetHomeDataParams {
  final int page;
  final int perPage;

  GetHomeDataParams({required this.page, this.perPage = 15});
}

class GetHomeDataUseCase extends UseCase<List<PexelsMedia>, GetHomeDataParams> {
  final HomeRepository repository;

  GetHomeDataUseCase(this.repository);

  @override
  Future<Either<Exception, List<PexelsMedia>>> call(GetHomeDataParams params) async {
    // Calculate how many videos to fetch (ratio 10:1)
    // For 15 photos, we want ~1-2 videos.
    final videoPerPage = max(1, (params.perPage / 10).ceil());

    final photosFuture = repository.fetchCuratedPhotos(
      page: params.page,
      perPage: params.perPage,
    );

    final videosFuture = repository.fetchPopularVideos(
      page: params.page,
      perPage: videoPerPage,
    );

    final results = await Future.wait([photosFuture, videosFuture]);

    final photosResult = results[0] as Either<Exception, List<PexelsPhoto>>;
    final videosResult = results[1] as Either<Exception, List<PexelsVideo>>;

    return photosResult.fold(
      (error) => Left(error),
      (photos) {
        // If videos fail, just return photos? Or fail everything?
        // Let's return photos if videos fail, to be robust.
        return videosResult.fold(
          (videoError) => Right(List<PexelsMedia>.from(photos)),
          (videos) {
            final mixedList = <PexelsMedia>[];
            final photoIter = photos.iterator;
            final videoIter = videos.iterator;

            // Simple mixing strategy: 10 photos then 1 video
            int count = 0;
            while (photoIter.moveNext()) {
              mixedList.add(photoIter.current);
              count++;
              if (count % 10 == 0 && videoIter.moveNext()) {
                mixedList.add(videoIter.current);
              }
            }
            
            // Add remaining videos if any (though usually we prioritize photos)
            // or just discard extra videos?
            // The user said "ratio of 10:1".
            
            return Right(mixedList);
          },
        );
      },
    );
  }
}
