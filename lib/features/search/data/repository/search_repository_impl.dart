import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/utils/app_logger.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/search/data/datasource/search_remote_datasource.dart';
import 'package:pinterest_clone/features/search/domain/repository/search_repository.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final remoteDataSource = ref.read(searchRemoteDataSourceProvider);
  return SearchRepositoryImpl(remoteDataSource);
});

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Exception, List<PexelsPhoto>>> fetchPhotos({
    required String query,
    required int page,
    int perPage = 20,
  }) async {
    try {
      final result = await remoteDataSource.fetchPhotos(
        query: query,
        page: page,
        perPage: perPage,
      );
      return Right(result);
    } catch (e) {
      AppLogger.logError('SearchRepositoryImpl: Error fetching photos', e);
      return Left(Exception(e.toString()));
    }
  }
}
