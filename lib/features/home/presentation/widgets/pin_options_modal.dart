import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:share_plus/share_plus.dart';

class PinOptionsModal extends StatelessWidget {
  final PexelsPhoto photo;

  const PinOptionsModal({super.key, required this.photo});

  static Future<void> show(BuildContext context, PexelsPhoto photo) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) => PinOptionsModal(photo: photo),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final double imageWidth = 120.0;
    final double aspectRatio = photo.width / photo.height;
    final double imageHeight = imageWidth / aspectRatio;

    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          margin: EdgeInsets.only(top: imageHeight / 2),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF212121) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: imageHeight / 2),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'This Pin is inspired by your recent activity',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionItem(
                context,
                icon: Icons.bookmark_border_rounded,
                label: 'Save',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildOptionItem(
                context,
                icon: Icons.download_rounded,
                label: 'Download image',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildOptionItem(
                context,
                icon: Icons.search_rounded,
                label: 'See more like this',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildOptionItem(
                context,
                icon: Icons.remove_circle_outline_rounded,
                label: 'See less like this',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildOptionItem(
                context,
                icon: Icons.share_outlined,
                label: 'Share',
                onTap: () {
                  Share.share(photo.url);
                  Navigator.pop(context);
                },
              ),
              _buildOptionItem(
                context,
                icon: Icons.report_gmailerrorred_rounded,
                label: 'Report pin',
                subtitle: 'This goes against Pinterest\'s Community Guidelines',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              // Extra padding for safety
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 20),
            ],
          ),
        ),

        Positioned(
          top: 0,
          child: Container(
            width: imageWidth,
            height: imageHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: photo.src.medium,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ),
        
        Positioned(
          top: imageHeight / 2 + 16,
          left: 16,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, size: 28, color: isDark ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
