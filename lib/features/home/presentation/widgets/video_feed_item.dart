import 'package:flutter/material.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_video_model.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoFeedItem extends StatefulWidget {
  final PexelsVideo video;
  final VoidCallback onTap;

  const VideoFeedItem({
    super.key,
    required this.video,
    required this.onTap,
  });

  @override
  State<VideoFeedItem> createState() => _VideoFeedItemState();
}

class _VideoFeedItemState extends State<VideoFeedItem> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Use the lowest quality for feed to save bandwidth/memory
    // Sort by size or width? Let's pick 'sd' or smallest width that is not super small
    // The video_files list has qualities.
    final videoFile = _selectVideoFile(widget.video.videoFiles);
    
    _controller = VideoPlayerController.networkUrl(Uri.parse(videoFile.link))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _initialized = true;
            _controller.setLooping(true);
            _controller.setVolume(0); // Muted by default in feed
            if (_isVisible) {
              _controller.play();
            }
          });
        }
      });
  }

  PexelsVideoFile _selectVideoFile(List<PexelsVideoFile> files) {
    // Prefer 'sd' or width around 360-540 for feed
    try {
      return files.firstWhere((f) => f.quality == 'sd' && f.width >= 360, orElse: () => files.first);
    } catch (e) {
      return files.first;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    
    final isVisible = info.visibleFraction > 0.5;
    if (_isVisible != isVisible) {
      setState(() {
        _isVisible = isVisible;
      });
      
      if (_initialized) {
        if (isVisible) {
          _controller.play();
        } else {
          _controller.pause();
        }
      }
    }
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video_${widget.video.id}'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: GestureDetector(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: [
              // Placeholder image while loading or if not initialized
              AspectRatio(
                aspectRatio: widget.video.width / widget.video.height,
                child: Image.network(
                  widget.video.image,
                  fit: BoxFit.cover,
                ),
              ),
              
              if (_initialized)
                AspectRatio(
                  aspectRatio: widget.video.width / widget.video.height,
                  child: VideoPlayer(_controller),
                ),
                
              // Timestamp
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.darkTextPrimary.withOpacity(0.7), // Using dark background as requested
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatDuration(widget.video.duration),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
