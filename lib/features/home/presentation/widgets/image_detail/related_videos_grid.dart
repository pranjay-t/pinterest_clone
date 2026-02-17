import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_video_model.dart';
import 'package:pinterest_clone/features/home/presentation/providers/related_videos_provider.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/pin_options_modal.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/video_feed_item.dart';
import 'package:shimmer/shimmer.dart';

class RelatedVideosGrid extends ConsumerWidget {
  final String videoId;

  const RelatedVideosGrid({super.key, required this.videoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relatedVideosState = ref.watch(relatedVideosProvider(videoId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _buildSectionTitle(
            'More to watch',
            isLoading: relatedVideosState.isLoading,
          ),
        ),
        const SizedBox(height: 12),
        relatedVideosState.isLoading
            ? _buildLoadingGrid()
            : _buildMasonryGrid(relatedVideosState.videos),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {required bool isLoading}) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: AppColors.darkTextTertiary,
        highlightColor: AppColors.darkTextSecondary.withAlpha(190),
        child: Container(
          width: 150,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildLoadingGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: AppColors.darkTextTertiary,
            highlightColor: AppColors.darkTextSecondary.withAlpha(190),
            child: Container(
              height: (index % 2 == 0 ? 200 : 300).toDouble(),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMasonryGrid(List<PexelsVideo> videos) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 5,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              VideoFeedItem(
                video: video,
                onTap: () {
                  context.push('/image_detail/${video.id}', extra: video);
                },
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  PinOptionsModal.show(context, video);
                },
                child: const Icon(Icons.more_horiz, size: 20),
              ),
            ],
          );
        },
      ),
    );
  }
}
