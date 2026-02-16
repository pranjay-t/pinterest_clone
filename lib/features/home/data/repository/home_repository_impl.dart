import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/utils/app_logger.dart';
import 'package:pinterest_clone/features/home/data/datasource/home_remote_datasource.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/domain/repository/home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final remoteDataSource = ref.read(homeRemoteDataSourceProvider);
  return HomeRepositoryImpl(remoteDataSource);
});

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Exception, List<PexelsPhoto>>> fetchCuratedPhotos({
    required int page,
    int perPage = 15,
  }) async {
    try {
      final result = await remoteDataSource.fetchCuratedPhotos(page: page, perPage: perPage);
      return Right(result);
    } catch (e) {
      AppLogger.logError('HomeRepositoryImpl: Error fetching photos', e);
      return Left(Exception(e.toString()));
    }
  }
}
