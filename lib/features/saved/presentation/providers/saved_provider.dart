import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pinterest_clone/core/utils/app_logger.dart';
import 'package:pinterest_clone/features/saved/data/datasources/saved_local_datasource.dart';
import 'package:pinterest_clone/features/saved/data/models/local_board_model.dart';
import 'package:pinterest_clone/features/saved/data/models/local_media_model.dart';
import 'package:pinterest_clone/features/saved/data/repositories/saved_repository_impl.dart';
import 'package:pinterest_clone/features/saved/domain/repositories/saved_repository.dart';
import 'package:pinterest_clone/features/saved/domain/usecases/saved_usecases.dart';

final savedLocalDataSourceProvider = Provider<SavedLocalDataSource>((ref) {
  return SavedLocalDataSourceImpl(
    mediaBox: Hive.box<LocalMediaModel>('saved_media'),
    boardBox: Hive.box<LocalBoardModel>('boards'),
  );
});

final savedRepositoryProvider = Provider<SavedRepository>((ref) {
  final dataSource = ref.watch(savedLocalDataSourceProvider);
  return SavedRepositoryImpl(dataSource);
});

final createBoardUseCaseProvider = Provider((ref) => CreateBoardUseCase(ref.watch(savedRepositoryProvider)));
final getBoardsUseCaseProvider = Provider((ref) => GetBoardsUseCase(ref.watch(savedRepositoryProvider)));
final saveMediaUseCaseProvider = Provider((ref) => SaveMediaUseCase(ref.watch(savedRepositoryProvider)));
final getSavedMediaUseCaseProvider = Provider((ref) => GetSavedMediaUseCase(ref.watch(savedRepositoryProvider)));
final isMediaSavedUseCaseProvider = Provider((ref) => IsMediaSavedUseCase(ref.watch(savedRepositoryProvider)));



// State Classes
class BoardsState {
  final List<LocalBoardModel> boards;
  final bool isLoading;
  final String? error;

  const BoardsState({
    this.boards = const [],
    this.isLoading = false,
    this.error,
  });

  BoardsState copyWith({
    List<LocalBoardModel>? boards,
    bool? isLoading,
    String? error,
  }) {
    return BoardsState(
      boards: boards ?? this.boards,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SavedMediaState {
  final List<LocalMediaModel> media;
  final bool isLoading;
  final String? error;

  const SavedMediaState({
    this.media = const [],
    this.isLoading = false,
    this.error,
  });

  SavedMediaState copyWith({
    List<LocalMediaModel>? media,
    bool? isLoading,
    String? error,
  }) {
    return SavedMediaState(
      media: media ?? this.media,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class BoardsNotifier extends StateNotifier<BoardsState> {
  final GetBoardsUseCase _getBoardsUseCase;
  final CreateBoardUseCase _createBoardUseCase;

  BoardsNotifier(this._getBoardsUseCase, this._createBoardUseCase)
      : super(const BoardsState()) {
    getBoards();
  }

  Future<void> getBoards() async {
    AppLogger.logDebug('BoardsNotifier: Fetching boards');
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getBoardsUseCase();
    result.fold(
      (failure) {
        AppLogger.logError('BoardsNotifier: Failed to fetch boards', failure);
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (boards) {
        AppLogger.logDebug('BoardsNotifier: Fetched ${boards.length} boards');
        state = state.copyWith(isLoading: false, boards: boards);
      },
    );
  }

  Future<void> createBoard(String name) async {
    final result = await _createBoardUseCase(name);
    result.fold(
      (failure) => AppLogger.logError('BoardsNotifier: Failed to create board', failure),
      (_) {
        getBoards();
      },
    );
  }
}

final boardsProvider = StateNotifierProvider<BoardsNotifier, BoardsState>((ref) {
  return BoardsNotifier(
    ref.watch(getBoardsUseCaseProvider),
    ref.watch(createBoardUseCaseProvider),
  );
});

class SavedMediaNotifier extends StateNotifier<SavedMediaState> {
  final GetSavedMediaUseCase _getSavedMediaUseCase;
  final SaveMediaUseCase _saveMediaUseCase;

  SavedMediaNotifier(this._getSavedMediaUseCase, this._saveMediaUseCase)
      : super(const SavedMediaState());

  Future<void> getSavedMedia({String? boardId}) async {
    AppLogger.logDebug('SavedMediaNotifier: Fetching media for board $boardId');
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getSavedMediaUseCase(boardId: boardId);
    result.fold(
      (failure) {
        AppLogger.logError('SavedMediaNotifier: Failed to fetch media', failure);
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (media) {
        AppLogger.logDebug('SavedMediaNotifier: Fetched ${media.length} items');
        state = state.copyWith(isLoading: false, media: media);
      },
    );
  }

  Future<void> saveMedia(LocalMediaModel media, {String? boardId}) async {
    final result = await _saveMediaUseCase(media, boardId: boardId);
    result.fold(
      (failure) => AppLogger.logError('SavedMediaNotifier: Failed to save media', failure),
      (_) {
        getSavedMedia(boardId: boardId); 
      },
    );
  }
}

final savedMediaProvider = StateNotifierProvider.family<SavedMediaNotifier, SavedMediaState, String?>((ref, boardId) {
  final notifier = SavedMediaNotifier(
    ref.watch(getSavedMediaUseCaseProvider),
    ref.watch(saveMediaUseCaseProvider),
  );
  notifier.getSavedMedia(boardId: boardId);
  return notifier;
});

final isMediaSavedProvider = FutureProvider.family<bool, String>((ref, mediaId) async {
  final useCase = ref.watch(isMediaSavedUseCaseProvider);
  final result = await useCase(mediaId);
  return result.fold((_) => false, (isSaved) => isSaved);
});
