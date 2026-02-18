import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/saved/presentation/providers/saved_provider.dart';
import 'package:pinterest_clone/features/saved/presentation/providers/layout_provider.dart';
import 'package:pinterest_clone/features/saved/presentation/widgets/saved_masonry_grid.dart';
import 'package:pinterest_clone/features/saved/presentation/widgets/select_layout_bottom_sheet.dart';

class MyAllSaveScreen extends ConsumerStatefulWidget {
  final String? boardId;
  final String? boardName;

  const MyAllSaveScreen({super.key, this.boardId, this.boardName});

  @override
  ConsumerState<MyAllSaveScreen> createState() => _MyAllSaveScreenState();
}

class _MyAllSaveScreenState extends ConsumerState<MyAllSaveScreen> {

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(savedMediaProvider(widget.boardId));
    final layout = ref.watch(pinLayoutProvider);

    int crossAxisCount = 2;
    switch (layout) {
      case PinLayout.wide:
        crossAxisCount = 1;
        break;
      case PinLayout.standard:
        crossAxisCount = 2;
        break;
      case PinLayout.compact:
        crossAxisCount = 3;
        break;
    }
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(Icons.arrow_back_ios, size: 28),
                  ),
                  Row(
                    children: [
                      Icon(Icons.person_add, size: 24),
                      SizedBox(width: 24),
                      Image.asset(
                        'assets/icons/share.png',
                        height: 20,
                        width: 20,
                        color: AppColors.lightBackground,
                      ),
                      SizedBox(width: 24),
                      Icon(Icons.more_horiz, size: 32),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                widget.boardName ?? 'All Saved',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              if (!state.isLoading && state.error == null)
                Text(
                  '${state.media.length} Pins',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkTextTertiary,
                  ),
                ),
                
              Align(
                alignment: AlignmentGeometry.centerRight,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: AppColors.darkCard,
                      builder: (context) => SelectLayoutBottomSheet(),
                    );
                  },
                  child: Image.asset(
                    'assets/icons/filter.png',
                    height: 28,
                    width: 28,
                    color: AppColors.lightBackground,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.isLoading && state.media.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.error != null && state.media.isEmpty) {
                      return Center(child: Text('Error: ${state.error}'));
                    }

                    if (state.media.isEmpty) {
                      return const Center(child: Text("No pins yet"));
                    }

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: SavedMasonryGrid(
                        key: ValueKey(crossAxisCount),
                        mediaList: state.media,
                        crossAxisCount: crossAxisCount,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
