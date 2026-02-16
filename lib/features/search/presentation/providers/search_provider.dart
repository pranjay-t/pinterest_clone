import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pinterest_clone/core/utils/app_logger.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/search/domain/usecase/search_photos_usecase.dart';

class SearchState {
  final List<PexelsPhoto> photos;
  final bool isLoading;
  final bool isMoreLoading;
  final String? error;
  final int page;
  final bool hasMore;
  final String currentQuery;

  const SearchState({
    this.photos = const [],
    this.isLoading = false,
    this.isMoreLoading = false,
    this.error,
    this.page = 1,
    this.hasMore = true,
    this.currentQuery = '',
  });

  SearchState copyWith({
    List<PexelsPhoto>? photos,
    bool? isLoading,
    bool? isMoreLoading,
    String? error,
    int? page,
    bool? hasMore,
    String? currentQuery,
  }) {
    return SearchState(
      photos: photos ?? this.photos,
      isLoading: isLoading ?? this.isLoading,
      isMoreLoading: isMoreLoading ?? this.isMoreLoading,
      error: error,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      currentQuery: currentQuery ?? this.currentQuery,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final SearchPhotosUseCase _searchPhotosUseCase;

  SearchNotifier(this._searchPhotosUseCase) : super(const SearchState());

  Future<void> searchPhotos(String query) async {
    if (query.isEmpty) return;
    
    // Reset state for new search
    state = state.copyWith(
      isLoading: true,
      photos: [],
      page: 1,
      hasMore: true,
      error: null,
      currentQuery: query,
    );

    final result = await _searchPhotosUseCase.execute(query: query, page: 1);

    result.fold(
      (error) => state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      ),
      (photos) => state = state.copyWith(
        isLoading: false,
        photos: photos,
        page: 2,
        hasMore: photos.isNotEmpty,
      ),
    );
  }

  Future<void> fetchMorePhotos() async {
    if (state.isMoreLoading || !state.hasMore || state.currentQuery.isEmpty) return;

    state = state.copyWith(isMoreLoading: true);

    final result = await _searchPhotosUseCase.execute(
      query: state.currentQuery,
      page: state.page,
    );

    result.fold(
      (error) {
        AppLogger.logError('Error fetching more search photos', Exception(error));
        state = state.copyWith(isMoreLoading: false); // Keep existing photos on error
      },
      (newPhotos) {
        if (newPhotos.isEmpty) {
          state = state.copyWith(isMoreLoading: false, hasMore: false);
        } else {
          state = state.copyWith(
            isMoreLoading: false,
            photos: [...state.photos, ...newPhotos],
            page: state.page + 1,
          );
        }
      },
    );
  }
}

final searchProvider = StateNotifierProvider.autoDispose<SearchNotifier, SearchState>((ref) {
  final useCase = ref.read(searchPhotosUseCaseProvider);
  return SearchNotifier(useCase);
});
