import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';

class ImageDetailHeader extends StatelessWidget {
  final PexelsPhoto photo;

  const ImageDetailHeader({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: photo.width / photo.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: photo.src.large2x,
          placeholder: (context, url) => Container(
            color: AppColors.darkTextTertiary.withOpacity(0.2),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
