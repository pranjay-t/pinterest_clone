import 'package:flutter/material.dart';
import 'package:pinterest_clone/core/common/custom_button.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_media_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_video_model.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/image_detail/image_options_bottom_sheet.dart';
import 'package:pinterest_clone/features/saved/data/models/local_media_model.dart';
import 'package:pinterest_clone/features/saved/presentation/widgets/save_to_board_modal.dart';

class ImageDetailActions extends StatelessWidget {
  final PexelsMedia media;
  const ImageDetailActions({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildActionButton(
              context,
              'assets/icons/heart_on.png',
              '38',
              AppColors.pinterestRed,
              0.9,
            ),
            const SizedBox(width: 16),
            _buildActionButton(
              context,
              'assets/icons/comment.png',
              '22',
              AppColors.lightBackground,
              0.95,
            ),
            const SizedBox(width: 16),
            _buildActionButton(
              context,
              'assets/icons/share.png',
              '',
              AppColors.lightBackground,
              0.8,
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                 // TODO: Update BottomSheet to support Media or check type
                 if (media is PexelsPhoto) {
                    ImageOptionsBottomSheet.show(context, media as PexelsPhoto);
                 }
              },
              child: _buildActionButton(
                context,
                'assets/icons/more.png',
                '',
                AppColors.lightBackground,
                1,
              ),
            ),
          ],
        ),
        CustomButton.solid(
          context: context,
          text: 'Save',
          onPressed: () {
            // Create LocalMediaModel
            String imageUrl = '';
            MediaType type = MediaType.photo;
            
            if (media is PexelsPhoto) {
              imageUrl = (media as PexelsPhoto).src.medium;
              type = MediaType.photo;
            } else if (media is PexelsVideo) {
              imageUrl = (media as PexelsVideo).image;
              type = MediaType.video;
            }

            final localMedia = LocalMediaModel(
              id: media.id.toString(),
              url: imageUrl,
              type: type,
              width: media.width,
              height: media.height,
              title: media.photographer, 
              description: media.url,
              photographer: media.photographer,
              photographerUrl: media.photographerUrl,
              savedAt: DateTime.now(),
            );

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => SaveToBoardModal(media: localMedia),
            );
          },
          backgroundColor: AppColors.pinterestRed,
          textColor: Colors.white,
          radius: 16,
          height: 40,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String path,
    String label,
    Color color,
    double scale,
  ) {
    return Row(
      children: [
        Transform.scale(
          scale: scale,
          child: Image.asset(
            path,
            height: 24,
            width: 24,
            color: color,
            fit: BoxFit.contain,
          ),
        ),
        if (label.isNotEmpty) ...[
          const SizedBox(width: 4),
          Text(label, style: Theme.of(context).textTheme.labelLarge),
        ],
      ],
    );
  }
}
