import 'package:flutter/material.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/saved/data/models/local_media_model.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SavedVideoFeedItem extends StatefulWidget {
  final LocalMediaModel video;
  final VoidCallback onTap;

  const SavedVideoFeedItem({
    super.key,
    required this.video,
    required this.onTap,
  });

  @override
  State<SavedVideoFeedItem> createState() => _SavedVideoFeedItemState();
}

class _SavedVideoFeedItemState extends State<SavedVideoFeedItem> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.video.videoUrl == null) return;
    
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl!))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _initialized = true;
            _controller.setLooping(true);
            _controller.setVolume(0);
            if (_isVisible) {
              _controller.play();
            }
          });
        }
      });
  }

  @override
  void dispose() {
    if (_initialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (!mounted || !_initialized) return;
    
    final isVisible = info.visibleFraction > 0.5;
    if (_isVisible != isVisible) {
      setState(() {
        _isVisible = isVisible;
      });
      
      if (isVisible) {
        _controller.play();
      } else {
        _controller.pause();
      }
    }
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return '';
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('saved_video_${widget.video.id}'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: GestureDetector(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: widget.video.width / widget.video.height,
                child: Image.network(
                  widget.video.url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: AppColors.darkCard),
                ),
              ),
              
              if (_initialized)
                AspectRatio(
                  aspectRatio: widget.video.width / widget.video.height,
                  child: VideoPlayer(_controller),
                ),
                
              if (widget.video.duration != null)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.darkTextPrimary.withOpacity(0.7), 
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
