import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/pin_options_modal.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/video_feed_item.dart';
import 'package:pinterest_clone/features/saved/data/models/local_media_model.dart';
import 'package:pinterest_clone/features/saved/presentation/screens/saved_media_detail_screen.dart';
import 'package:pinterest_clone/features/saved/presentation/widgets/saved_video_feed_item.dart';

class SavedMasonryGrid extends StatelessWidget {
  final List<LocalMediaModel> mediaList;
  final ScrollController? scrollController;

  const SavedMasonryGrid({
    super.key,
    required this.mediaList,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      controller: scrollController,
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 5,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: mediaList.length,
      itemBuilder: (context, index) {
        final item = mediaList[index];
        
        void navigateToDetail() {
          if (item.pexelsPhoto != null) {
             context.push('/image_detail/${item.pexelsPhoto!.id}', extra: item.pexelsPhoto);
          } else if (item.pexelsVideo != null) {
             context.push('/image_detail/${item.pexelsVideo!.id}', extra: item.pexelsVideo);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SavedMediaDetailScreen(media: item),
              ),
            );
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (item.pexelsVideo != null)
              VideoFeedItem(
                video: item.pexelsVideo!,
                onTap: navigateToDetail,
              )
            else if (item.type == MediaType.video && item.videoUrl != null)
              SavedVideoFeedItem(
                video: item,
                onTap: navigateToDetail,
              )
            else
              GestureDetector(
                onTap: navigateToDetail,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: item.url,
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
              ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () {
                if (item.pexelsPhoto != null) {
                  PinOptionsModal.show(context, item.pexelsPhoto);
                } else if (item.pexelsVideo != null) {
                  PinOptionsModal.show(context, item.pexelsVideo);
                } else {
                  PinOptionsModal.show(context, item);
                }
              },
              child: const Icon(Icons.more_horiz, size: 20),
            ),
          ],
        );
      },
    );
  }
}
