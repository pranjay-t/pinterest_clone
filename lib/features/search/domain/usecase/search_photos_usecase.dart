import 'dart:math';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_media_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_video_model.dart';
import 'package:pinterest_clone/features/search/data/repository/search_repository_impl.dart';
import 'package:pinterest_clone/features/search/domain/repository/search_repository.dart';

final searchPhotosUseCaseProvider = Provider<SearchPhotosUseCase>((ref) {
  final repository = ref.read(searchRepositoryProvider);
  return SearchPhotosUseCase(repository);
});

class SearchPhotosUseCase {
  final SearchRepository repository;

  SearchPhotosUseCase(this.repository);

  Future<Either<Exception, List<PexelsMedia>>> execute({
    required String query,
    required int page,
    int perPage = 20,
  }) async {
    // Calculate videos to fetch (ratio 10:1)
    // For 20 photos, ~2 videos.
    final videoPerPage = max(1, (perPage / 10).ceil());

    final photosFuture = repository.fetchPhotos(
      query: query,
      page: page,
      perPage: perPage,
    );

    final videosFuture = repository.searchVideos(
      query: query,
      page: page,
      perPage: videoPerPage,
    );

    final results = await Future.wait([photosFuture, videosFuture]);

    final photosResult = results[0] as Either<Exception, List<PexelsPhoto>>;
    final videosResult = results[1] as Either<Exception, List<PexelsVideo>>;

    return photosResult.fold(
      (error) => Left(error),
      (photos) {
        return videosResult.fold(
          (videoError) => Right(List<PexelsMedia>.from(photos)),
          (videos) {
            final mixedList = <PexelsMedia>[];
            final photoIter = photos.iterator;
            final videoIter = videos.iterator;

            int count = 0;
            while (photoIter.moveNext()) {
              mixedList.add(photoIter.current);
              count++;
              if (count % 10 == 0 && videoIter.moveNext()) {
                mixedList.add(videoIter.current);
              }
            }
            return Right(mixedList);
          },
        );
      },
    );
  }
}
