import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:share_plus/share_plus.dart';

class ImageOptionsBottomSheet extends StatelessWidget {
  final PexelsPhoto photo;

  const ImageOptionsBottomSheet({super.key, required this.photo});

  static void show(BuildContext context, PexelsPhoto photo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkBackground,
      builder: (context) => ImageOptionsBottomSheet(photo: photo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkSurfaceVariant,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildHeader(context),
          const Divider(thickness: 0.5, color: AppColors.darkTextPrimary),
          const SizedBox(height: 12),

          _buildOption(context, 'Follow ${photo.photographer}', onTap: () {}),
          _buildOption(
            context,
            'Copy link',
            onTap: () {
              context.pop();
            },
          ),
          _buildOption(
            context,
            'Download image',
            onTap: () {
              context.pop();
            },
          ),
          _buildOption(
            context,
            'Add to collage',
            onTap: () {
              context.pop();
            },
          ),
          _buildOption(
            context,
            'See more like this',
            onTap: () {
              context.pop();
            },
          ),
          _buildOption(
            context,
            'See less like this',
            onTap: () {
              context.pop();
            },
          ),
          _buildOption(
            context,
            'Report pin',
            subtitle: "This goes against Pinterest's community guidelines",
            onTap: () {
              context.pop();
            },
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 0.5, color: AppColors.darkTextPrimary),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(width: 2),

          GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(Icons.close_outlined, size: 28),
          ),
          SizedBox(width: 16),
          const Text(
            'Options',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    String title, {
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.lightSurface,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
