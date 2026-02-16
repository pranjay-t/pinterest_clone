import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinterest_clone/core/common/custom_button.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';

class ImageDetailInfo extends StatelessWidget {
  final PexelsPhoto photo;

  const ImageDetailInfo({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
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
                child: CachedNetworkImage(imageUrl: photo.src.small),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              photo.photographer,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (photo.alt.isNotEmpty) ...[
          Text(
            photo.alt,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
