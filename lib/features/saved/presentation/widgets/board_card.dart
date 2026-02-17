import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';

class BoardCard extends StatelessWidget {
  final String? imageUrl;
  final List<String> previewImages;

  const BoardCard({super.key, this.imageUrl, this.previewImages = const []});

  @override
  Widget build(BuildContext context) {
    final List<String> imagesToShow = [...previewImages];
    if (imagesToShow.isEmpty && imageUrl != null && imageUrl!.isNotEmpty) {
      imagesToShow.add(imageUrl!);
    }

    return Container(
      width: 190,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(right: 1),
              child: imagesToShow.isNotEmpty
                  ? _buildImage(imagesToShow[0])
                  : Container(color: AppColors.darkCard),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 1),
                    child: imagesToShow.length > 1
                        ? _buildImage(imagesToShow[1])
                        : Container(color: AppColors.darkCard),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: imagesToShow.length > 2
                        ? _buildImage(imagesToShow[2])
                        : Container(color: AppColors.darkCard),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => Container(color: AppColors.darkCard),
      errorWidget: (context, url, error) =>
          Container(color: AppColors.darkCard),
    );
  }
}
