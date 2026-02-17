import 'package:dartz/dartz.dart';
import 'package:pinterest_clone/core/common/failure.dart';
import 'package:pinterest_clone/features/saved/data/models/local_board_model.dart';
import 'package:pinterest_clone/features/saved/data/models/local_media_model.dart';
import 'package:pinterest_clone/features/saved/domain/repositories/saved_repository.dart';

class CreateBoardUseCase {
  final SavedRepository repository;

  CreateBoardUseCase(this.repository);

  Future<Either<Failure, void>> call(String name) {
    return repository.createBoard(name);
  }
}

class GetBoardsUseCase {
  final SavedRepository repository;

  GetBoardsUseCase(this.repository);

  Future<Either<Failure, List<LocalBoardModel>>> call() {
    return repository.getBoards();
  }
}

class SaveMediaUseCase {
  final SavedRepository repository;

  SaveMediaUseCase(this.repository);

  Future<Either<Failure, void>> call(LocalMediaModel media, {String? boardId}) {
    return repository.saveMedia(media, boardId: boardId);
  }
}

class GetSavedMediaUseCase {
  final SavedRepository repository;

  GetSavedMediaUseCase(this.repository);

  Future<Either<Failure, List<LocalMediaModel>>> call({String? boardId}) {
    return repository.getSavedMedia(boardId: boardId);
  }
}

class IsMediaSavedUseCase {
  final SavedRepository repository;

  IsMediaSavedUseCase(this.repository);

  Future<Either<Failure, bool>> call(String mediaId) {
    return repository.isMediaSaved(mediaId);
  }
}
