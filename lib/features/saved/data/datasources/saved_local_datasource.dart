import 'package:hive_flutter/hive_flutter.dart';
import 'package:pinterest_clone/core/utils/app_logger.dart';
import 'package:pinterest_clone/features/saved/data/models/local_board_model.dart';
import 'package:pinterest_clone/features/saved/data/models/local_media_model.dart';

abstract class SavedLocalDataSource {
  Future<void> saveMedia(LocalMediaModel media);
  Future<List<LocalMediaModel>> getSavedMedia({String? boardId});
  Future<void> createBoard(LocalBoardModel board);
  Future<List<LocalBoardModel>> getBoards();
  Future<void> addMediaToBoard(String mediaId, String boardId);
  Future<bool> isMediaSaved(String mediaId);
  Future<void> removeMedia(String mediaId);
}

class SavedLocalDataSourceImpl implements SavedLocalDataSource {
  final Box<LocalMediaModel> mediaBox;
  final Box<LocalBoardModel> boardBox;

  SavedLocalDataSourceImpl({
    required this.mediaBox,
    required this.boardBox,
  });

  @override
  Future<void> createBoard(LocalBoardModel board) async {
    await boardBox.put(board.id, board);
  }

  @override
  Future<List<LocalBoardModel>> getBoards() async {
    final boards = boardBox.values.toList();
    
    // Check and backfill preview images if empty
    for (var board in boards) {
      if (board.previewImages.isEmpty) {
        // Find media for this board
        final boardMedia = mediaBox.values
            .where((m) => m.boardIds.contains(board.id))
            .take(3)
            .toList();

        // Calculate count just in case it's 0 but media exists
        final realCount = mediaBox.values.where((m) => m.boardIds.contains(board.id)).length;
        if (board.pinCount != realCount) {
             board.pinCount = realCount;
             await board.save();
        }

        if (boardMedia.isNotEmpty) {
          // Sort or just take recent? The box usually iterates safe.
          // Let's just take what we found to fill it. 
          // Ideally we want savedAt desc, but this is a quick fix.
          // Let's sorting by savedAt desc to be nice.
          final allBoardMedia = mediaBox.values
             .where((m) => m.boardIds.contains(board.id))
             .toList();
          
          allBoardMedia.sort((a, b) => b.savedAt.compareTo(a.savedAt)); // Newest first

          board.previewImages = allBoardMedia
              .take(3)
              .map((m) => m.url)
              .toList();

          if (board.coverImage == null && board.previewImages.isNotEmpty) {
            board.coverImage = board.previewImages.first;
          }
          
          await board.save();
        }
      }
    }

    return boards;
  }

  @override
  Future<List<LocalMediaModel>> getSavedMedia({String? boardId}) async {
    if (boardId == null) {
      return mediaBox.values.toList();
    } else {
      return mediaBox.values
          .where((media) => media.boardIds.contains(boardId))
          .toList();
    }
  }

  @override
  Future<void> saveMedia(LocalMediaModel media) async {
    await mediaBox.put(media.id, media);
  }

  @override
  Future<void> addMediaToBoard(String mediaId, String boardId) async {
    final media = mediaBox.get(mediaId);
    if (media != null) {
      if (!media.boardIds.contains(boardId)) {
        media.boardIds.add(boardId);
        await media.save();
      }
      
      final board = boardBox.get(boardId);
      if (board != null) {
        if (board.coverImage == null) {
          board.coverImage = media.url;
        }
        
        // Add to preview images
        if (!board.previewImages.contains(media.url)) {
          board.previewImages.insert(0, media.url); // Add to start
          if (board.previewImages.length > 3) {
            board.previewImages = board.previewImages.sublist(0, 3);
          }
        }
        
        board.pinCount++; // Increment count
        await board.save();
      }
    }
  }

  @override
  Future<bool> isMediaSaved(String mediaId) async {
    return mediaBox.containsKey(mediaId);
  }

  @override
  Future<void> removeMedia(String mediaId) async {
    await mediaBox.delete(mediaId);
  }
}
