import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/presentation/providers/home_provider.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/image_detail/image_detail_actions.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/image_detail/image_detail_header.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/image_detail/image_detail_info.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/image_detail/related_photos_grid.dart';

class ImageDetailScreen extends ConsumerStatefulWidget {
  final String imageId;
  final PexelsPhoto? photo;

  const ImageDetailScreen({super.key, required this.imageId, this.photo});

  @override
  ConsumerState<ImageDetailScreen> createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends ConsumerState<ImageDetailScreen> {
  PexelsPhoto? _photo;

  @override
  void initState() {
    super.initState();
    if (widget.photo != null) {
      _photo = widget.photo;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _findPhoto();
      });
    }
  }

  void _findPhoto() {
    final homeState = ref.read(homeProvider);
    try {
      final photo = homeState.photos.firstWhere(
        (p) => p.id.toString() == widget.imageId,
      );
      setState(() {
        _photo = photo;
      });
    } catch (_) {
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_photo == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final photo = _photo!;

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
                        ImageDetailHeader(photo: photo),
                        const SizedBox(height: 8),
                        ImageDetailActions(photo: photo),
                        const SizedBox(height: 8),
                        ImageDetailInfo(photo: photo),
                        RelatedPhotosGrid(imageId: widget.imageId),
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
}
