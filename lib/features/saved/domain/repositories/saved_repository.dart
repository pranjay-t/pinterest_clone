import 'package:dartz/dartz.dart';
import 'package:pinterest_clone/core/common/failure.dart';
import 'package:pinterest_clone/features/saved/data/models/local_board_model.dart';
import 'package:pinterest_clone/features/saved/data/models/local_media_model.dart';

abstract class SavedRepository {
  Future<Either<Failure, void>> createBoard(String name);
  Future<Either<Failure, List<LocalBoardModel>>> getBoards();
  Future<Either<Failure, void>> saveMedia(LocalMediaModel media, {String? boardId});
  Future<Either<Failure, List<LocalMediaModel>>> getSavedMedia({String? boardId});
  Future<Either<Failure, bool>> isMediaSaved(String mediaId);
}
