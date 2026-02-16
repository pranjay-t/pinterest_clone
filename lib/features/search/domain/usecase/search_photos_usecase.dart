import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/search/data/repository/search_repository_impl.dart';
import 'package:pinterest_clone/features/search/domain/repository/search_repository.dart';

final searchPhotosUseCaseProvider = Provider<SearchPhotosUseCase>((ref) {
  final repository = ref.read(searchRepositoryProvider);
  return SearchPhotosUseCase(repository);
});

class SearchPhotosUseCase {
  final SearchRepository repository;

  SearchPhotosUseCase(this.repository);

  Future<Either<Exception, List<PexelsPhoto>>> execute({
    required String query,
    required int page,
    int perPage = 20,
  }) {
    return repository.fetchPhotos(query: query, page: page, perPage: perPage);
  }
}
