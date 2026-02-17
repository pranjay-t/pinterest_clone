import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/core/utils/app_logger.dart';
import 'package:pinterest_clone/features/saved/data/models/local_board_model.dart';
import 'package:pinterest_clone/features/saved/data/models/local_media_model.dart';
import 'package:pinterest_clone/features/saved/presentation/providers/saved_provider.dart';

class SaveToBoardModal extends ConsumerWidget {
  final LocalMediaModel media;

  const SaveToBoardModal({super.key, required this.media});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardsState = ref.watch(boardsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.lightBackground,
                          size: 28,
                        ),
                      ),
                    ),
                    const Text(
                      'Save to board',
                      style: TextStyle(
                        color: AppColors.lightBackground,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pop();
                        context.push('/create_board');
                      },
                      child: _buildIconItem('Create board', Icons.add),
                    ),

                    const SizedBox(height: 16),

                    const SizedBox(height: 16),
                    
                    Builder(
                      builder: (context) {
                        if (boardsState.isLoading && boardsState.boards.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        if (boardsState.error != null && boardsState.boards.isEmpty) {
                          return Text('Error loading boards: ${boardsState.error}');
                        }

                        return Column(
                          children: boardsState.boards
                              .map((board) => GestureDetector(
                                    onTap: () async {
                                      AppLogger.logDebug('SaveToBoardModal: Saving to board ${board.name} (${board.id})');
                                      await ref
                                          .read(savedMediaProvider(board.id).notifier)
                                          .saveMedia(media, boardId: board.id);
                                      
                                      AppLogger.logDebug('SaveToBoardModal: Invalidating providers');
                                      ref.invalidate(savedMediaProvider(null));
                                      ref.invalidate(boardsProvider); 
                                      ref.invalidate(savedMediaProvider(board.id));

                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Saved to ${board.name}')),
                                        );
                                      }
                                    },
                                    child: _buildBoardItem(board),
                                  ))
                              .toList(),
                        );
                      },
                    ),
                    
                    GestureDetector(
                      onTap: () async {
                        AppLogger.logDebug('SaveToBoardModal: Saving to Profile');
                        await ref
                            .read(savedMediaProvider(null).notifier)
                            .saveMedia(media);
                        
                        AppLogger.logDebug('SaveToBoardModal: Invalidating providers');
                        ref.invalidate(savedMediaProvider(null));
                        ref.invalidate(boardsProvider);

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Saved to Profile')),
                          );
                        }
                      },
                      child: _buildIconItem('Profile', Icons.person),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIconItem(String label, IconData iconData) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.darkTextDisabled,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(iconData, color: AppColors.lightBackground, size: 28),
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              color: AppColors.lightBackground,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardItem(LocalBoardModel board) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.darkTextDisabled,
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: board.coverImage != null
                ? CachedNetworkImage(
                    imageUrl: board.coverImage!,
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Text(
            board.name,
            style: const TextStyle(
              color: AppColors.lightBackground,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
