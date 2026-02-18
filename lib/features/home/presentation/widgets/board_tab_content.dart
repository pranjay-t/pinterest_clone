import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/home/presentation/providers/home_provider.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/masonry_media_grid.dart';
import 'package:pinterest_clone/features/saved/data/models/local_board_model.dart';
import 'package:pinterest_clone/features/saved/presentation/providers/saved_provider.dart';

class BoardTabContent extends ConsumerStatefulWidget {
  final LocalBoardModel board;

  const BoardTabContent({super.key, required this.board});

  @override
  ConsumerState<BoardTabContent> createState() => _BoardTabContentState();
}

class _BoardTabContentState extends ConsumerState<BoardTabContent> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Fetch media for this board
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(savedMediaProvider(widget.board.id).notifier)
          .getSavedMedia(boardId: widget.board.id);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final homeState = ref.read(homeProvider);
      if (!homeState.isMoreLoading && homeState.hasMore) {
        ref.read(homeProvider.notifier).fetchMorePhotos();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedMediaState = ref.watch(savedMediaProvider(widget.board.id));
    final homeState = ref.watch(homeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.board.name,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${widget.board.pinCount} Pins',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.lightBackground,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your saves',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightBackground,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push(
                          '/board_details/${widget.board.id}',
                          extra: widget.board.name,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.lightTextSecondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_forward, size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (savedMediaState.isLoading)
                  const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  )
                else if (savedMediaState.media.isNotEmpty)
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: savedMediaState.media.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final media = savedMediaState.media[index];
                        return GestureDetector(
                          onTap: () {
                            final extra =
                                media.pexelsPhoto ?? media.pexelsVideo;
                            if (extra != null) {
                              context.push(
                                '/image_detail/${media.id}',
                                extra: extra,
                              );
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: media.url,
                              width: 80,
                              height: 120,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(color: Colors.grey[300]),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.error),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(
                    height: 120,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "No pins saved yet",
                      style: theme.textTheme.bodySmall,
                    ),
                  ),

                const SizedBox(height: 32),
                Text(
                  "More ideas for this board",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        if (homeState.isLoading && homeState.photos.isEmpty)
          const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator.adaptive()),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            sliver: MasonryMediaGrid(items: homeState.photos, isSliver: true),
          ),

        if (homeState.isMoreLoading)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
          ),
      ],
    );
  }
}
