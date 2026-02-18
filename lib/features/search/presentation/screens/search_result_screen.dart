import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/common/pinterest_refresh_indicator.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_video_model.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/video_feed_item.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/pin_options_modal.dart';
import 'package:pinterest_clone/features/search/presentation/providers/search_provider.dart';
import 'package:pinterest_clone/features/saved/data/models/local_media_model.dart';
import 'package:pinterest_clone/features/saved/presentation/widgets/save_to_board_modal.dart';
import 'package:shimmer/shimmer.dart';

class SearchResultScreen extends ConsumerStatefulWidget {
  final String query;
  final String? contextualText;
  final bool showTags;

  const SearchResultScreen({
    super.key,
    required this.query,
    this.contextualText,
    this.showTags = false,
  });

  @override
  ConsumerState<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends ConsumerState<SearchResultScreen> {
  final ScrollController _scrollController = ScrollController();
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.query);
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchProvider.notifier).searchPhotos(widget.query);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(searchProvider.notifier).fetchMorePhotos();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildHeader(context),
            if (widget.contextualText != null) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.contextualText!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
            const SizedBox(height: 10),
            if (widget.showTags) _buildTagsList(),
            const SizedBox(height: 10),
            Expanded(
              child: PinterestRefreshIndicator(
                onRefresh: () async {
                  ref.read(searchProvider.notifier).searchPhotos(widget.query);
                },
                child: searchState.isLoading && searchState.photos.isEmpty
                    ? _buildLoadingGrid()
                    : searchState.error != null && searchState.photos.isEmpty
                    ? _buildErrorView(searchState.error!)
                    : _buildMasonryGrid(searchState),
              ),
            ),
            if (searchState.isMoreLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 24),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.darkBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.darkTextPrimary),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                widget.query,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.tune, size: 28), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildTagsShimmer() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 6,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: AppColors.darkTextTertiary,
            highlightColor: AppColors.darkTextSecondary.withAlpha(190),
            child: Container(
              width: index == 0 ? 50 : 100,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTagsList() {
    final tags = [
      'Aesthetic',
      'Drawing',
      'Wallpaper',
      'Outfit',
      'Design',
      'Art',
      'Background',
      'Portrait',
    ];
    final colors = [
      Colors.redAccent,
      Colors.blueAccent,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: tags.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              final newQuery = '${widget.query} ${tags[index]}';
              context.push(
                '/search_result/$newQuery',
                extra: {'showTags': true},
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tags[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMasonryGrid(SearchState state) {
    if (state.photos.isEmpty && !state.isLoading) {
      return const Center(child: Text("No results found"));
    }

    return MasonryGridView.count(
      controller: _scrollController,
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 5,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: state.photos.length,
      itemBuilder: (context, index) {
        final item = state.photos[index];
        if (item is PexelsVideo) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              VideoFeedItem(
                video: item,
                onTap: () {
                  context.push('/image_detail/${item.id}', extra: item);
                },
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  PinOptionsModal.show(context, item);
                },
                child: const Icon(Icons.more_horiz, size: 20),
              ),
            ],
          );
        } else if (item is PexelsPhoto) {
          return _buildPinItem(item);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPinItem(PexelsPhoto photo) {
    return GestureDetector(
      onTap: () {
        context.push('/image_detail/${photo.id}', extra: photo);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: photo.src.large,
                  placeholder: (context, url) => AspectRatio(
                    aspectRatio: photo.width / photo.height,
                    child: Container(color: Colors.grey.shade200),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    final localMedia = LocalMediaModel(
                      id: photo.id.toString(),
                      url: photo.src.large,
                      type: MediaType.photo,
                      width: photo.width,
                      height: photo.height,
                      title: photo.alt,
                      description: photo.alt,
                      photographer: photo.photographer,
                      photographerUrl: photo.photographerUrl,
                      savedAt: DateTime.now(),
                      pexelsPhoto: photo,
                    );

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => SaveToBoardModal(media: localMedia),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.darkTextDisabled.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      'assets/icons/save_pin_on.png',
                      height: 14,
                      width: 14,
                      color: AppColors.lightBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () {
              PinOptionsModal.show(context, photo);
            },
            child: const Icon(Icons.more_horiz, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkTextTertiary,
      highlightColor: AppColors.darkTextSecondary.withAlpha(190),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            height: (index % 2 == 0 ? 200 : 300).toDouble(),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(error, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                ref.read(searchProvider.notifier).searchPhotos(widget.query),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
