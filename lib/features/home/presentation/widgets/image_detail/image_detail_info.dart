import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinterest_clone/core/common/custom_button.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_media_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_video_model.dart';

class ImageDetailInfo extends StatelessWidget {
  final PexelsMedia media;

  const ImageDetailInfo({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    String imageUrl = '';
    if (media is PexelsPhoto) {
      imageUrl = (media as PexelsPhoto).src.small;
    } else if (media is PexelsVideo) {
      imageUrl = (media as PexelsVideo).image;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 9,
              backgroundColor: Colors.grey,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(imageUrl: imageUrl),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              media.photographer,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (media is PexelsPhoto && (media as PexelsPhoto).alt.isNotEmpty) ...[
          Text(
            (media as PexelsPhoto).alt,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
        ] else if (media is PexelsVideo) ...[
           // Videos might not have 'alt' in the basic model or we interpret it differently.
           // We can render 'Video Content' or just skip if no description.
           const Text(
            "Video Content", 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
        ],
        CustomButton.solid(
          context: context,
          width: double.infinity,
          radius: 12,
          text: 'Visit',
          onPressed: () {},
          backgroundColor: AppColors.darkTextDisabled,
          textColor: Colors.white,
        ),
      ],
    );
  }
}
