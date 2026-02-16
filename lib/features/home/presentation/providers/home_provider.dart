import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pinterest_clone/core/utils/app_logger.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/data/repository/home_repository_impl.dart';
import 'package:pinterest_clone/features/home/domain/usecases/get_home_data_usecase.dart';

class HomeState {
  final List<PexelsPhoto> photos;
  final bool isLoading;
  final bool isMoreLoading;
  final int page;
  final bool hasMore;
  final String? error;

  HomeState({
    this.photos = const [],
    this.isLoading = false,
    this.isMoreLoading = false,
    this.page = 1,
    this.hasMore = true,
    this.error,
  });

  HomeState copyWith({
    List<PexelsPhoto>? photos,
    bool? isLoading,
    bool? isMoreLoading,
    int? page,
    bool? hasMore,
    String? error,
  }) {
    return HomeState(
      photos: photos ?? this.photos,
      isLoading: isLoading ?? this.isLoading,
      isMoreLoading: isMoreLoading ?? this.isMoreLoading,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final GetHomeDataUseCase _getHomeDataUseCase;

  HomeNotifier(this._getHomeDataUseCase) : super(HomeState()) {
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);
    AppLogger.logInfo('HomeNotifier: Initial fetch started');

    final result = await _getHomeDataUseCase(GetHomeDataParams(page: 1));

    result.fold(
      (error) {
        state = state.copyWith(isLoading: false, error: error.toString());
        AppLogger.logError('HomeNotifier: Initial fetch failed', error);
      },
      (photos) {
        state = state.copyWith(
          photos: photos,
          isLoading: false,
          page: 1,
          hasMore: photos.isNotEmpty,
        );
        AppLogger.logInfo(
          'HomeNotifier: Initial fetch success, count: ${photos.length}',
        );
      },
    );
  }

  Future<void> fetchMorePhotos() async {
    if (state.isMoreLoading || !state.hasMore) return;

    state = state.copyWith(isMoreLoading: true, error: null);
    final nextPage = state.page + 1;
    AppLogger.logInfo('HomeNotifier: Fetching more photos (page $nextPage)');

    final result = await _getHomeDataUseCase(GetHomeDataParams(page: nextPage));

    result.fold(
      (error) {
        state = state.copyWith(isMoreLoading: false, error: error.toString());
        AppLogger.logError('HomeNotifier: Fetch more failed', error);
      },
      (newPhotos) {
        if (newPhotos.isEmpty) {
          state = state.copyWith(isMoreLoading: false, hasMore: false);
          AppLogger.logInfo('HomeNotifier: No more photos to fetch');
        } else {
          state = state.copyWith(
            photos: [...state.photos, ...newPhotos],
            isMoreLoading: false,
            page: nextPage,
            hasMore: true,
          );
          AppLogger.logInfo(
            'HomeNotifier: Fetch more success. Total: ${state.photos.length}',
          );
        }
      },
    );
  }

  Future<void> refresh() async {
    AppLogger.logInfo('HomeNotifier: Refreshing...');
    await fetchPhotos();
  }
}

final getHomeDataUseCaseProvider = Provider<GetHomeDataUseCase>((ref) {
   final repository = ref.read(homeRepositoryProvider);
   return GetHomeDataUseCase(repository);
});

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final useCase = ref.read(getHomeDataUseCaseProvider);
  return HomeNotifier(useCase);
});
