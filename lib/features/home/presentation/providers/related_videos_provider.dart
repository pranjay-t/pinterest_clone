import 'dart:math';

import 'package:flutter_riverpod/legacy.dart';
import 'package:pinterest_clone/core/utils/app_logger.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_video_model.dart';
import 'package:pinterest_clone/features/home/data/repository/home_repository_impl.dart';
import 'package:pinterest_clone/features/home/domain/repository/home_repository.dart';
import 'package:pinterest_clone/features/home/presentation/providers/home_provider.dart';

class RelatedVideosState {
  final List<PexelsVideo> videos;
  final bool isLoading;
  final String? error;

  RelatedVideosState({
    this.videos = const [],
    this.isLoading = false,
    this.error,
  });

  RelatedVideosState copyWith({
    List<PexelsVideo>? videos,
    bool? isLoading,
    String? error,
  }) {
    return RelatedVideosState(
      videos: videos ?? this.videos,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class RelatedVideosNotifier extends StateNotifier<RelatedVideosState> {
  final HomeRepository _repository;
  final String videoId;

  RelatedVideosNotifier(this._repository, this.videoId)
    : super(RelatedVideosState()) {
    fetchRelatedVideos();
  }

  Future<void> fetchRelatedVideos() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    await Future.delayed(const Duration(seconds: 1));

    final randomPage = Random().nextInt(5) + 1;
    
    // Fetch popular videos directly from repository
    final result = await _repository.fetchPopularVideos(
      page: randomPage,
      perPage: 10,
    );

    result.fold(
      (error) {
        if (mounted) {
          state = state.copyWith(isLoading: false, error: error.toString());
        }
        AppLogger.logError('RelatedVideosNotifier: Fetch failed', error);
      },
      (videos) {
        if (mounted) {
          final filtered = videos
              .where((v) => v.id.toString() != videoId)
              .toList();
          state = state.copyWith(videos: filtered, isLoading: false);
        }
      },
    );
  }
}

final relatedVideosProvider = StateNotifierProvider.family
    .autoDispose<RelatedVideosNotifier, RelatedVideosState, String>((
      ref,
      videoId,
    ) {
      final repository = ref.read(homeRepositoryProvider);
      return RelatedVideosNotifier(repository, videoId);
    });
