import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_media_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_video_model.dart';
import 'package:pinterest_clone/features/saved/data/models/local_media_model.dart';
import 'package:pinterest_clone/features/saved/presentation/widgets/save_to_board_modal.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pinterest_clone/core/widgets/custom_toast.dart';

class PinOptionsModal extends StatelessWidget {
  final dynamic media;

  const PinOptionsModal({super.key, required this.media});

  Future<void> _downloadMedia(ScaffoldMessengerState messenger) async {
    try {
      // Check permissions (Gal handles this, but good to be aware)
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
        // Try to get HD or closest to it
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
      } else if (media is LocalMediaModel) {
        downloadUrl = (media as LocalMediaModel).url;
        // Check if it's a video based on type or extension if needed,
        // but LocalMediaModel should have a type.
        if ((media as LocalMediaModel).type == MediaType.video) {
          isVideo = true;
          if ((media as LocalMediaModel).videoUrl != null) {
            downloadUrl = (media as LocalMediaModel).videoUrl;
          }
        }
      }

       if (downloadUrl == null || downloadUrl.isEmpty) {
        CustomToast.showWithMessenger(
            messenger, 'Could not find media to download');
        return;
      }

      // Show loading indicator (using standard snackbar for loading, or maybe custom too? let's stick to custom)
      CustomToast.showWithMessenger(messenger, 'Downloading...');

      // Apply a unique filename
      final directory = await getTemporaryDirectory();
      final extension = isVideo ? 'mp4' : 'jpg'; 
      // You might want to parse the extension from the URL if possible, 
      // but defaulting to mp4/jpg is often safe enough for Pexels.
      
      final filePath = '${directory.path}/pinterest_download_${DateTime.now().millisecondsSinceEpoch}.$extension';

      await Dio().download(downloadUrl, filePath);

      // Save to gallery
      if (isVideo) {
        await Gal.putVideo(filePath);
      } else {
        await Gal.putImage(filePath);
      }

      CustomToast.showWithMessenger(messenger, 'Saved to Gallery!');
      
      // Cleanup temp file
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }

    } catch (e) {
      debugPrint('Download error: $e');
      debugPrint('Download error: $e');
      CustomToast.showWithMessenger(messenger, 'Failed to download: $e');
    }
  }

  static Future<void> show(BuildContext context, dynamic media) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) => PinOptionsModal(media: media),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final double imageWidth = 120.0;
    // Handle aspect ratio safely
    final double width = (media is LocalMediaModel) ? media.width.toDouble() : media.width.toDouble();
    final double height = (media is LocalMediaModel) ? media.height.toDouble() : media.height.toDouble();
    final double aspectRatio = width / height;
    final double imageHeight = imageWidth / aspectRatio;
    
    String imageUrl = '';
    if (media is PexelsPhoto) {
      imageUrl = (media as PexelsPhoto).src.medium;
    } else if (media is PexelsVideo) {
      imageUrl = (media as PexelsVideo).image;
    } else if (media is LocalMediaModel) {
      imageUrl = (media as LocalMediaModel).url;
    }

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
              if (media is! LocalMediaModel) ...[
                _buildOptionItem(
                  context,
                  imgPath: 'assets/icons/save_pin.png',
                  label: 'Save',
                  onTap: () {
                    Navigator.pop(context);
                    
                    // Create LocalMediaModel
                    String imageUrl = '';
                    String? videoUrl;
                    int? duration;
                    MediaType type = MediaType.photo;
                    PexelsPhoto? pexelsPhoto;
                    PexelsVideo? pexelsVideo;
                    
                    if (media is PexelsPhoto) {
                      imageUrl = (media as PexelsPhoto).src.medium;
                      type = MediaType.photo;
                      pexelsPhoto = media as PexelsPhoto;
                    } else if (media is PexelsVideo) {
                      final video = media as PexelsVideo;
                      imageUrl = video.image;
                      type = MediaType.video;
                      duration = video.duration;
                      pexelsVideo = video;
                      
                      // Select best video file (SD or similar logic to feed)
                       try {
                        final videoFile = video.videoFiles.firstWhere(
                          (f) => f.quality == 'sd' && f.width >= 360, 
                          orElse: () => video.videoFiles.first
                        );
                        videoUrl = videoFile.link;
                      } catch (e) {
                         if (video.videoFiles.isNotEmpty) {
                           videoUrl = video.videoFiles.first.link;
                         }
                      }
                    }

                    final localMedia = LocalMediaModel(
                      id: media.id.toString(),
                      url: imageUrl,
                      type: type,
                      width: media.width,
                      height: media.height,
                      title: media.photographer, // Using photographer as title/desc for now
                      description: media.url,
                      photographer: media.photographer,
                      photographerUrl: media.photographerUrl,
                      savedAt: DateTime.now(),
                      videoUrl: videoUrl,
                      duration: duration,
                      pexelsPhoto: pexelsPhoto,
                      pexelsVideo: pexelsVideo,
                    );

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => SaveToBoardModal(media: localMedia),
                    );
                  },
                ),
                SizedBox(height: 8),
              ] else ...[
                 _buildOptionItem(
                  context,
                  imgPath: 'assets/icons/save_pin.png',
                  label: 'Organize', // Already saved
                  onTap: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => SaveToBoardModal(media: media),
                    );
                  },
                ),
                SizedBox(height: 8),
              ],
              _buildOptionItem(
                context,
                label: 'Share',
                imgPath: 'assets/icons/share.png',
                onTap: () {
                  Share.share(media.url);
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 8),

              _buildOptionItem(
                context,
                label: 'Search image',
                scale: 1.1,
                imgPath: 'assets/icons/search_off.png',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 8),

              _buildOptionItem(
                context,
                label: (media is PexelsVideo || (media is LocalMediaModel && media.type == MediaType.video)) 
                    ? 'Download video' 
                    : 'Download image',
                imgPath: 'assets/icons/download.png',
                onTap: () {
                  final messenger = ScaffoldMessenger.of(context);
                  Navigator.pop(context);
                  _downloadMedia(messenger);
                },
              ),

              SizedBox(height: 8),

              _buildOptionItem(
                context,
                label: 'See more like this',
                imgPath: 'assets/icons/heart_off.png',
                onTap: () {
                  final messenger = ScaffoldMessenger.of(context);
                  Navigator.pop(context);
                  CustomToast.showWithMessenger(
                    messenger,
                    "Ok! We'll show you more like this",
                    onUndo: () {
                      debugPrint("Undo see more");
                    },
                  );
                },
              ),
              SizedBox(height: 8),

              _buildOptionItem(
                context,
                label: 'See less like this',
                imgPath: 'assets/icons/see_less.png',
                scale: 1.4,
                onTap: () {
                  final messenger = ScaffoldMessenger.of(context);
                  Navigator.pop(context);
                  CustomToast.showWithMessenger(
                    messenger,
                    "Ok! We'll show you less like this",
                    onUndo: () {
                      // Undo logic here
                      debugPrint("Undo see less");
                    },
                  );
                },
              ),

              SizedBox(height: 8),

              _buildOptionItem(
                context,
                imgPath: 'assets/icons/report.png',
                label: 'Report pin',
                scale: 0.9,
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
                imageUrl: imageUrl,
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
          top: imageHeight / 2 + 12,
          left: 12,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              size: 28,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionItem(
    BuildContext context, {
    required String label,
    String? imgPath,
    required VoidCallback onTap,
    double? scale = 1,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Row(
          children: [
            Transform.scale(
              scale: scale,
              child: Image.asset(
                imgPath!,
                height: 18,
                width: 18,
                color: AppColors.lightBackground,
              ),
            ),
            SizedBox(width: 16),
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
