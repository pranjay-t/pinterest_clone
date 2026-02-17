import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/common/custom_text_field.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/core/utils/app_logger.dart';
import 'package:pinterest_clone/features/saved/presentation/screens/my_all_save_screen.dart';

import 'package:pinterest_clone/features/saved/presentation/widgets/board_card.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/features/saved/presentation/providers/saved_provider.dart';

class BoardsTabScreen extends ConsumerStatefulWidget {
  const BoardsTabScreen({super.key});

  @override
  ConsumerState<BoardsTabScreen> createState() => _BoardsTabScreenState();
}

class _BoardsTabScreenState extends ConsumerState<BoardsTabScreen> {
  // final List<Map<String, dynamic>> _boards = []; // Removed dummy data
  void _showSortingOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCard,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sort by',
              style: TextStyle(
                color: AppColors.lightBackground,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            _buildLayoutOption('A to Z'),
            _buildLayoutOption('Last saved to'),
            _buildLayoutOption('Newest', isSelected: true),
            _buildLayoutOption('Oldest'),

            SizedBox(height: 24),
            Align(
              alignment: AlignmentGeometry.center,
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkTextDisabled,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: AppColors.lightBackground,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLayoutOption(String title, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.lightBackground,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isSelected)
            Icon(Icons.check, color: AppColors.lightBackground, size: 28),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.darkTextTertiary),
    );
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: 'Search your Pins',
                textInputAction: TextInputAction.search,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Transform.scale(
                    scale: 0.85,
                    child: Image.asset(
                      'assets/icons/search_off.png',
                      height: 24,
                      width: 24,
                      color: AppColors.lightBackground,
                    ),
                  ),
                ),
                fillColor: AppColors.darkBackground,
                border: border,
                enabledBorder: border,
                focusedBorder: border.copyWith(
                  borderSide: const BorderSide(
                    color: AppColors.darkTextPrimary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () => context.pop(),
              child: Image.asset(
                'assets/icons/plus.png',
                height: 22,
                width: 22,
                color: AppColors.lightBackground,
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            GestureDetector(
              onTap: () => _showSortingOptions(context),
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.darkTextDisabled,
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/sorting.png',
                      height: 22,
                      width: 22,
                      fit: BoxFit.cover,
                      color: AppColors.lightBackground,
                    ),
                    Transform.scale(
                      scale: 1.8,
                      child: Image.asset(
                        'assets/icons/down.png',
                        color: AppColors.lightBackground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8),
            Container(
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.darkTextDisabled,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Text(
                  'Group',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Builder(
            builder: (context) {
              final state = ref.watch(boardsProvider);

              if (state.isLoading && state.boards.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.error != null && state.boards.isEmpty) {
                AppLogger.logError('BoardsTabScreen: Error loading boards', Exception(state.error));
                return Center(child: Text('Error: ${state.error}'));
              }

              final boards = state.boards;
              AppLogger.logDebug('BoardsTabScreen: Displaying ${boards.length} boards');
              
              if (boards.isEmpty) {
                return Center(
                  child: Text(
                    'No boards yet. Create one!',
                    style: TextStyle(color: AppColors.lightTextSecondary),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 2,
                  childAspectRatio: 0.8,
                ),
                itemCount: boards.length,
                itemBuilder: (context, index) {
                  final board = boards[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyAllSaveScreen(
                            boardId: board.id,
                            boardName: board.name,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BoardCard(
                          imageUrl: board.coverImage,
                          previewImages: board.previewImages,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          board.name,
                          style: const TextStyle(
                            color: AppColors.lightBackground,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${board.pinCount} Pins',
                          style: const TextStyle(
                            color: AppColors.lightTextSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
