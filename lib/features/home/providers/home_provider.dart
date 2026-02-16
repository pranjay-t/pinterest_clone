import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pinterest_clone/core/utils/app_logger.dart';
import 'package:pinterest_clone/features/home/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/repository/home_repository.dart';

// State definition
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

// Notifier
class HomeNotifier extends StateNotifier<HomeState> {
  final HomeRepository _repository;

  HomeNotifier(this._repository) : super(HomeState()) {
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);
    AppLogger.logInfo('HomeNotifier: Initial fetch started');

    try {
      final photos = await _repository.fetchCuratedPhotos(page: 1);
      state = state.copyWith(
        photos: photos,
        isLoading: false,
        page: 1,
        hasMore: photos.isNotEmpty,
      );
      AppLogger.logInfo(
        'HomeNotifier: Initial fetch success, count: ${photos.length}',
      );
    } catch (e, st) {
      state = state.copyWith(isLoading: false, error: e.toString());
      AppLogger.logError('HomeNotifier: Initial fetch failed', e, st);
    }
  }

  Future<void> fetchMorePhotos() async {
    if (state.isMoreLoading || !state.hasMore) return;

    state = state.copyWith(isMoreLoading: true, error: null);
    final nextPage = state.page + 1;
    AppLogger.logInfo('HomeNotifier: Fetching more photos (page $nextPage)');

    try {
      final newPhotos = await _repository.fetchCuratedPhotos(page: nextPage);

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
    } catch (e, st) {
      state = state.copyWith(isMoreLoading: false, error: e.toString());
      AppLogger.logError('HomeNotifier: Fetch more failed', e, st);
    }
  }

  Future<void> refresh() async {
    AppLogger.logInfo('HomeNotifier: Refreshing...');
    await fetchPhotos();
  }
}

// Provider
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final repository = ref.read(homeRepositoryProvider);
  return HomeNotifier(repository);
});
