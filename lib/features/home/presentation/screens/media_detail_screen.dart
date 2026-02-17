import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_media_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_video_model.dart';
import 'package:pinterest_clone/features/home/presentation/providers/home_provider.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/image_detail/image_detail_actions.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/image_detail/image_detail_info.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/image_detail/image_detail_info.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/image_detail/related_photos_grid.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/image_detail/related_videos_grid.dart';
import 'package:pinterest_clone/features/search/presentation/providers/search_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MediaDetailScreen extends ConsumerStatefulWidget {
  final String mediaId;
  final PexelsMedia? media;

  const MediaDetailScreen({super.key, required this.mediaId, this.media});

  @override
  ConsumerState<MediaDetailScreen> createState() => _MediaDetailScreenState();
}

class _MediaDetailScreenState extends ConsumerState<MediaDetailScreen> {
  PexelsMedia? _media;
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isPlaying = false;
  bool _isMuted = true; // Start muted
  bool _showControls = false; // Start with controls hidden for better UI
  bool _isManuallyPaused = false;

  @override
  void initState() {
    super.initState();
    if (widget.media != null) {
      _media = widget.media;
      _initMedia();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _findMedia();
      });
    }
  }

  void _findMedia() {
    // Try finding in HomeProvider first, then SearchProvider
    final homeState = ref.read(homeProvider);
    try {
      final media = homeState.photos.firstWhere(
        (p) => p.id.toString() == widget.mediaId,
      );
      setState(() {
        _media = media;
        _initMedia();
      });
      return;
    } catch (_) {}

    final searchState = ref.read(searchProvider);
    try {
      final media = searchState.photos.firstWhere(
        (p) => p.id.toString() == widget.mediaId,
      );
      setState(() {
        _media = media;
        _initMedia();
      });
    } catch (_) {
      if (mounted) context.pop();
    }
  }

  void _initMedia() {
    if (_media is PexelsVideo) {
      final video = _media as PexelsVideo;
      final videoFile = _selectVideoFile(video.videoFiles);

      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(videoFile.link))
            ..initialize().then((_) {
              if (mounted) {
                setState(() {
                  _isVideoInitialized = true;
                  _videoController!.setLooping(true);
                  _videoController!.setVolume(0);
                  _videoController!.play();
                  _isPlaying = true;
                  _showControls = false; // Ensure controls are hidden on auto-play
                });
              }
            });

      _videoController!.addListener(() {
        if (mounted) {
          // Update UI on progress
          setState(() {});
        }
      });
    }
  }

  PexelsVideoFile _selectVideoFile(List<PexelsVideoFile> files) {
    try {
      return files.firstWhere(
        (f) => f.quality == 'hd' || f.width >= 720,
        orElse: () => files.first,
      );
    } catch (e) {
      return files.first;
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_videoController == null || !_isVideoInitialized) return;

    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
        _isPlaying = false;
        _isManuallyPaused = true; // User manually paused
        _showControls = true;
      } else {
        _videoController!.play();
        _isPlaying = true;
        _isManuallyPaused = false; // User manually played
      }
    });
  }

  void _toggleMute() {
    if (_videoController == null) return;
    setState(() {
      _isMuted = !_isMuted;
      _videoController!.setVolume(_isMuted ? 0 : 1);
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _enterFullScreen() {
    // For now, simpler implementation or just placeholder as true fullscreen requires context changes
    // We can just expand the video to cover mostly everything or rely on a package.
    // Getting full screen in flutter often requires pushing a new route or SystemChrome updates.
    // Let's just log for now or show a snackbar as it's complex to do perfectly in one go.
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Full screen mode')));
  }

  @override
  Widget build(BuildContext context) {
    if (_media == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_media is PexelsPhoto)
                          _buildPhotoHeader(_media as PexelsPhoto)
                        else if (_media is PexelsVideo)
                          _buildVideoPlayer(_media as PexelsVideo),

                        const SizedBox(height: 8),
                        // Reusing existing widgets that expect PexelsPhoto.
                        // Check if compatible or need refactoring.
                        // ImageDetailActions expects PexelsPhoto.
                        // If video, we might show different actions or mock it.
                        // For now if Photo, show actions. If Video, show rudimentary actions?
                        if (_media is PexelsPhoto) ...[
                          ImageDetailActions(media: _media as PexelsPhoto),
                          const SizedBox(height: 8),
                          ImageDetailInfo(media: _media as PexelsPhoto),
                          RelatedPhotosGrid(imageId: widget.mediaId),
                        ] else if (_media is PexelsVideo) ...[
                          ImageDetailActions(media: _media as PexelsVideo),
                          const SizedBox(height: 8),
                          ImageDetailInfo(media: _media as PexelsVideo),
                          RelatedVideosGrid(videoId: widget.mediaId),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 20,
              left: 20,
              child: GestureDetector(
                onTap: () => context.pop(),
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
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoHeader(PexelsPhoto photo) {
    return AspectRatio(
      aspectRatio: photo.width / photo.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: photo.src.large2x,
          placeholder: (context, url) =>
              Container(color: AppColors.darkTextTertiary.withOpacity(0.2)),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(PexelsVideo video) {
    final aspectRatio = video.width / video.height;

    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls = !_showControls;
        });
      },
      child: VisibilityDetector(
        key: Key('video-${video.id}'),
        onVisibilityChanged: (info) {
          if (_videoController == null || !_isVideoInitialized) return;

          final visiblePercentage = info.visibleFraction * 100;
          if (visiblePercentage < 50 && _isPlaying) {
            _videoController!.pause();
            setState(() {
              _isPlaying = false;
            });
          } else if (visiblePercentage >= 50 &&
              !_isPlaying &&
              !_isManuallyPaused) {
            _videoController!.play();
            setState(() {
              _isPlaying = true;
            });
          }
        },
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_isVideoInitialized)
                  VideoPlayer(_videoController!)
                else
                  Image.network(video.image, fit: BoxFit.cover),

                if (_showControls || !_isPlaying)
                  GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),

                if (_showControls && _isVideoInitialized)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black54, Colors.transparent],
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _formatDuration(_videoController!.value.position),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Expanded(
                            child: VideoProgressIndicator(
                              _videoController!,
                              allowScrubbing: true,
                              colors: VideoProgressColors(
                                playedColor: AppColors.lightTextDisabled,
                                bufferedColor: Colors.white24,
                                backgroundColor: Colors.white10,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                          ),
                          Text(
                            _formatDuration(_videoController!.value.duration),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {}, // Caption dummy
                            child: const Icon(
                              Icons.closed_caption,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: _toggleMute,
                            child: Icon(
                              _isMuted ? Icons.volume_off : Icons.volume_up,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: _enterFullScreen,
                            child: const Icon(
                              Icons.fullscreen,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
