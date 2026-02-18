import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_media_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_video_model.dart';
import 'package:pinterest_clone/features/home/presentation/providers/related_photos_provider.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/video_feed_item.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/pin_options_modal.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pinterest_clone/features/saved/data/models/local_media_model.dart';
import 'package:pinterest_clone/features/saved/presentation/widgets/save_to_board_modal.dart';

class RelatedPhotosGrid extends ConsumerWidget {
  final String imageId;

  const RelatedPhotosGrid({super.key, required this.imageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relatedPhotosState = ref.watch(relatedPhotosProvider(imageId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _buildSectionTitle(
            'More to explore',
            isLoading: relatedPhotosState.isLoading,
          ),
        ),
        const SizedBox(height: 12),
        relatedPhotosState.isLoading
            ? _buildLoadingGrid()
            : _buildMasonryGrid(relatedPhotosState.photos),
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

  void _onSave(BuildContext context, PexelsMedia item) {
    String imageUrl = '';
    MediaType type = MediaType.photo;

    if (item is PexelsPhoto) {
      imageUrl = item.src.medium;
      type = MediaType.photo;
    } else if (item is PexelsVideo) {
      imageUrl = item.image;
      type = MediaType.video;
    }

    final localMedia = LocalMediaModel(
      id: item.id.toString(),
      url: imageUrl,
      type: type,
      width: item.width,
      height: item.height,
      title: item.photographer,
      description: item.url,
      photographer: item.photographer,
      photographerUrl: item.photographerUrl,
      savedAt: DateTime.now(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SaveToBoardModal(media: localMedia),
    );
  }

  Widget _buildSaveButton(BuildContext context, PexelsMedia item) {
    return Positioned(
      bottom: 8,
      right: 8,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, right: 8),
        child: GestureDetector(
          onTap: () => _onSave(context, item),
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
    );
  }

  Widget _buildMasonryGrid(List<PexelsMedia> photos) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 5,
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final item = photos[index];
          if (item is PexelsVideo) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      VideoFeedItem(
                        video: item,
                        onTap: () {
                          context.push('/image_detail/${item.id}', extra: item);
                        },
                      ),
                      _buildSaveButton(context, item),
                    ],
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
          } else if (item is PexelsPhoto) {
            return Container(
              child: GestureDetector(
                onTap: () {
                  context.push('/image_detail/${item.id}', extra: item);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: item.src.large,
                            placeholder: (context, url) => AspectRatio(
                              aspectRatio: item.width / item.height,
                              child: Container(
                                color: AppColors.darkTextTertiary.withOpacity(
                                  0.2,
                                ),
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                        _buildSaveButton(context, item),
                      ],
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
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
