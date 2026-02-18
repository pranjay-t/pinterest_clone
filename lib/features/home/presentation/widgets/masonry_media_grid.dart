import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_video_model.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/pin_options_modal.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/video_feed_item.dart';

class MasonryMediaGrid extends StatelessWidget {
  final List<dynamic> items;
  final ScrollController? scrollController;
  final bool isSliver;

  const MasonryMediaGrid({
    super.key,
    required this.items,
    this.scrollController,
    this.isSliver = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isSliver) {
      return SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 5,
        childCount: items.length,
        itemBuilder: (context, index) => _buildItem(context, items[index]),
      );
    }

    return MasonryGridView.count(
      controller: scrollController,
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 5,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildItem(context, items[index]),
    );
  }

  Widget _buildItem(BuildContext context, dynamic item) {
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
                errorWidget: (context, url, error) => const Icon(Icons.error),
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
  }
}
