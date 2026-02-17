import 'dart:math';

import 'package:flutter_riverpod/legacy.dart';
import 'package:pinterest_clone/core/utils/app_logger.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_media_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/domain/usecases/get_home_data_usecase.dart';
import 'package:pinterest_clone/features/home/presentation/providers/home_provider.dart';

class RelatedPhotosState {
  final List<PexelsMedia> photos;
  final bool isLoading;
  final String? error;

  RelatedPhotosState({
    this.photos = const [],
    this.isLoading = false,
    this.error,
  });

  RelatedPhotosState copyWith({
    List<PexelsMedia>? photos,
    bool? isLoading,
    String? error,
  }) {
    return RelatedPhotosState(
      photos: photos ?? this.photos,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class RelatedPhotosNotifier extends StateNotifier<RelatedPhotosState> {
  final GetHomeDataUseCase _getHomeDataUseCase;
  final String imageId;

  RelatedPhotosNotifier(this._getHomeDataUseCase, this.imageId)
    : super(RelatedPhotosState()) {
    fetchRelatedPhotos();
  }

  Future<void> fetchRelatedPhotos() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    await Future.delayed(const Duration(seconds: 1));

    final randomPage = Random().nextInt(10) + 1;
    final result = await _getHomeDataUseCase(
      GetHomeDataParams(page: randomPage),
    );

    result.fold(
      (error) {
        if (mounted) {
          state = state.copyWith(isLoading: false, error: error.toString());
        }
        AppLogger.logError('RelatedPhotosNotifier: Fetch failed', error);
      },
      (photos) {
        if (mounted) {
          final filtered = photos
              .where((p) => p.id.toString() != imageId)
              .toList();
          state = state.copyWith(photos: filtered, isLoading: false);
        }
      },
    );
  }
}

final relatedPhotosProvider = StateNotifierProvider.family
    .autoDispose<RelatedPhotosNotifier, RelatedPhotosState, String>((
      ref,
      imageId,
    ) {
      final useCase = ref.read(getHomeDataUseCaseProvider);
      return RelatedPhotosNotifier(useCase, imageId);
    });
