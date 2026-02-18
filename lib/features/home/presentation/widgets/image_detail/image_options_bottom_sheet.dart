import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/core/widgets/custom_toast.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_media_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_video_model.dart';
import 'package:gal/gal.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ImageOptionsBottomSheet extends StatelessWidget {
  final PexelsMedia media;

  const ImageOptionsBottomSheet({super.key, required this.media});

  static void show(BuildContext context, PexelsMedia media) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkBackground,
      builder: (context) => ImageOptionsBottomSheet(media: media),
    );
  }

  Future<void> _downloadMedia(ScaffoldMessengerState messenger) async {
    try {
      if (!await Gal.hasAccess()) {
        await Gal.requestAccess();
      }

      String? downloadUrl;
      bool isVideo = false;

      if (media is PexelsPhoto) {
        downloadUrl = (media as PexelsPhoto).src.original;
      } else if (media is PexelsVideo) {
        isVideo = true;
        final video = media as PexelsVideo;
        try {
          final videoFile = video.videoFiles.firstWhere(
            (f) => f.quality == 'hd',
            orElse: () => video.videoFiles.first,
          );
          downloadUrl = videoFile.link;
        } catch (e) {
          if (video.videoFiles.isNotEmpty) {
            downloadUrl = video.videoFiles.first.link;
          }
        }
      }

      if (downloadUrl == null || downloadUrl.isEmpty) {
        CustomToast.showWithMessenger(
          messenger,
          'Could not find media to download',
        );
        return;
      }

      CustomToast.showWithMessenger(messenger, 'Downloading...');

      final directory = await getTemporaryDirectory();
      final extension = isVideo ? 'mp4' : 'jpg';
      final filePath =
          '${directory.path}/pinterest_download_${DateTime.now().millisecondsSinceEpoch}.$extension';

      await Dio().download(downloadUrl, filePath);

      if (isVideo) {
        await Gal.putVideo(filePath);
      } else {
        await Gal.putImage(filePath);
      }

      CustomToast.showWithMessenger(messenger, 'Saved to Gallery!');

      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Download error: $e');
      CustomToast.showWithMessenger(messenger, 'Failed to download: $e');
    }
  }

  void _copyLink(ScaffoldMessengerState messenger) {
    Clipboard.setData(ClipboardData(text: media.url));
    CustomToast.showWithMessenger(
      messenger,
      'Link copied',
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(messenger.context).size.height - 130,
        left: 40,
        right: 40,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isVideo = media is PexelsVideo;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkSurfaceVariant,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildHeader(context),
          const Divider(thickness: 0.5, color: AppColors.darkTextPrimary),
          const SizedBox(height: 12),
          _buildOption(context, 'Follow ${media.photographer}', onTap: () {}),
          _buildOption(
            context,
            'Copy link',
            onTap: () {
              final messenger = ScaffoldMessenger.of(context);
              context.pop();
              _copyLink(messenger);
            },
          ),
          _buildOption(
            context,
            isVideo ? 'Download video' : 'Download image',
            onTap: () {
              final messenger = ScaffoldMessenger.of(context);
              context.pop();
              _downloadMedia(messenger);
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
              final messenger = ScaffoldMessenger.of(context);
              context.pop();
              CustomToast.showWithMessenger(
                messenger,
                "Ok! We'll show you more like this",
                onUndo: () {
                  debugPrint("Undo see more");
                },
              );
            },
          ),
          _buildOption(
            context,
            'See less like this',
            onTap: () {
              final messenger = ScaffoldMessenger.of(context);
              context.pop();
              CustomToast.showWithMessenger(
                messenger,
                "Ok! We'll show you less like this",
                onUndo: () {
                  debugPrint("Undo see less");
                },
              );
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
          const SizedBox(width: 2),
          GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(Icons.close_outlined, size: 28),
          ),
          const SizedBox(width: 16),
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
