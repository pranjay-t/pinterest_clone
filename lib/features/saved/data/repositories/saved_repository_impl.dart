import 'package:dartz/dartz.dart';
import 'package:pinterest_clone/core/common/failure.dart';
import 'package:pinterest_clone/core/utils/app_logger.dart';
import 'package:pinterest_clone/features/saved/data/datasources/saved_local_datasource.dart';
import 'package:pinterest_clone/features/saved/data/models/local_board_model.dart';
import 'package:pinterest_clone/features/saved/data/models/local_media_model.dart';
import 'package:pinterest_clone/features/saved/domain/repositories/saved_repository.dart';
import 'package:uuid/uuid.dart';

class SavedRepositoryImpl implements SavedRepository {
  final SavedLocalDataSource dataSource;

  SavedRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, void>> createBoard(String name) async {
    try {
      AppLogger.logInfo('Creating board: $name');
      final board = LocalBoardModel(
        id: const Uuid().v4(),
        name: name,
        createdAt: DateTime.now(),
      );
      await dataSource.createBoard(board);
      AppLogger.logInfo('Board created successfully: ${board.id}');
      return const Right(null);
    } catch (e) {
      AppLogger.logError('Failed to create board', e);
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LocalBoardModel>>> getBoards() async {
    try {
      final boards = await dataSource.getBoards();
      return Right(boards);
    } catch (e) {
      AppLogger.logError('Failed to fetch boards', e);
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveMedia(LocalMediaModel media,
      {String? boardId}) async {
    try {
      AppLogger.logInfo('Saving media: ${media.id} to board: $boardId');
      final exists = await dataSource.isMediaSaved(media.id);
      
      if (exists) {
        if (boardId != null) {
          await dataSource.addMediaToBoard(media.id, boardId);
        }
      } else {
        // Save new media first
        await dataSource.saveMedia(media);
        
        // Then link to board if provided
        if (boardId != null) {
          await dataSource.addMediaToBoard(media.id, boardId);
        }
      }
      AppLogger.logInfo('Media saved successfully');
      return const Right(null);
    } catch (e) {
      AppLogger.logError('Failed to save media', e);
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LocalMediaModel>>> getSavedMedia(
      {String? boardId}) async {
    try {
      final media = await dataSource.getSavedMedia(boardId: boardId);
      return Right(media);
    } catch (e) {
      AppLogger.logError('Failed to fetch saved media', e);
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isMediaSaved(String mediaId) async {
    try {
      final result = await dataSource.isMediaSaved(mediaId);
      return Right(result);
    } catch (e) {
      AppLogger.logError('Error checking isMediaSaved', e);
      return Left(Failure(e.toString()));
    }
  }
}
