import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/pin_options_modal.dart';
import 'package:pinterest_clone/features/saved/data/models/local_media_model.dart';
import 'package:video_player/video_player.dart';

class SavedMediaDetailScreen extends StatefulWidget {
  final LocalMediaModel media;

  const SavedMediaDetailScreen({super.key, required this.media});

  @override
  State<SavedMediaDetailScreen> createState() => _SavedMediaDetailScreenState();
}

class _SavedMediaDetailScreenState extends State<SavedMediaDetailScreen> {
  VideoPlayerController? _videoController;
  bool _initialized = false;
  bool _isPlaying = false;
  bool _showControls = false;

  @override
  void initState() {
    super.initState();
    if (widget.media.type == MediaType.video && widget.media.videoUrl != null) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.media.videoUrl!))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _initialized = true;
              _videoController!.setLooping(true);
              _videoController!.play();
              _isPlaying = true;
            });
          }
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_videoController == null || !_initialized) return;
    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
        _isPlaying = false;
      } else {
        _videoController!.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Hero(
                tag: widget.media.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _buildContent(),
                ),
              ),
            ),
            if (widget.media.type == MediaType.video && _initialized)
              GestureDetector(
                onTap: _togglePlayPause,
                 behavior: HitTestBehavior.translucent,
                 child: SizedBox.expand(
                   child: !_isPlaying ? Center(
                     child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow, color: Colors.white, size: 50),
                     ),
                   ) : (_showControls ? Center(
                     child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.pause, color: Colors.white, size: 50),
                     ),
                   ) : const SizedBox()),
                 ),
              ),

            Positioned(
              top: 20,
              left: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.lightBackground.withOpacity(0.6),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/back.png',
                      height: 32,
                      width: 32,
                      color: AppColors.darkSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: GestureDetector(
                 onTap: () {
                   if (widget.media.type == MediaType.video) {
                      setState(() {
                        _showControls = !_showControls;
                      });
                   }
                   PinOptionsModal.show(context, widget.media);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.lightBackground.withOpacity(0.6),
                  ),
                  child: const Icon(
                    Icons.more_horiz,
                    size: 32,
                    color: AppColors.darkSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.media.type == MediaType.video && _initialized) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    }
    return CachedNetworkImage(
      imageUrl: widget.media.url,
      fit: BoxFit.contain,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
