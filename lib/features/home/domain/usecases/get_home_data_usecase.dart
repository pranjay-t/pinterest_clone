import 'package:dartz/dartz.dart';
import 'package:pinterest_clone/core/usecase/usecase.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/domain/repository/home_repository.dart';

class GetHomeDataParams {
  final int page;
  final int perPage;

  GetHomeDataParams({required this.page, this.perPage = 15});
}

class GetHomeDataUseCase extends UseCase<List<PexelsPhoto>, GetHomeDataParams> {
  final HomeRepository repository;

  GetHomeDataUseCase(this.repository);

  @override
  Future<Either<Exception, List<PexelsPhoto>>> call(GetHomeDataParams params) {
    return repository.fetchCuratedPhotos(page: params.page, perPage: params.perPage);
  }
}
