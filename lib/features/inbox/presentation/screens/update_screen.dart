import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_video_model.dart';
import 'package:pinterest_clone/features/home/presentation/providers/home_provider.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/pin_options_modal.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/video_feed_item.dart';
import 'package:shimmer/shimmer.dart';

class UpdateScreen extends ConsumerStatefulWidget {
  final String title;
  const UpdateScreen({super.key, required this.title});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends ConsumerState<UpdateScreen> {
  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back_ios, size: 24),
        ),
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: homeState.isLoading && homeState.photos.isEmpty
          ? _buildLoadingShimmer()
          : homeState.error != null && homeState.photos.isEmpty
          ? _buildErrorView(homeState.error!)
          : _buildMasonryGrid(homeState),
    );
  }

  Widget _buildMasonryGrid(HomeState state) {
    return MasonryGridView.count(
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
          return GestureDetector(
            onTap: () {
              context.push('/image_detail/${item.id}', extra: item);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: item.src.large,
                    placeholder: (context, url) => AspectRatio(
                      aspectRatio: item.width / item.height,
                      child: Container(
                        color: AppColors.darkTextTertiary.withOpacity(0.2),
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {
                    PinOptionsModal.show(context, item);
                  },
                  child: const Icon(Icons.more_horiz, size: 20),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingShimmer() {
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
          Text(
            'Something went wrong',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(error, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.read(homeProvider.notifier).refresh(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
