import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/common/custom_text_field.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/core/utils/app_logger.dart';
import 'package:pinterest_clone/features/saved/presentation/providers/saved_provider.dart';
import 'package:pinterest_clone/features/saved/presentation/widgets/saved_masonry_grid.dart';
import 'package:pinterest_clone/features/saved/presentation/widgets/select_layout_bottom_sheet.dart';

class PinsTabScreen extends ConsumerStatefulWidget {
  const PinsTabScreen({super.key});

  @override
  ConsumerState<PinsTabScreen> createState() => _PinsTabScreenState();
}

class _PinsTabScreenState extends ConsumerState<PinsTabScreen> {
  void _showLayoutOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCard,
      builder: (context) => SelectLayoutBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.darkTextTertiary),
    );
    final state = ref.watch(savedMediaProvider(null));

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: 'Search your Pins',
                textInputAction: TextInputAction.search,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Transform.scale(
                    scale: 0.85,
                    child: Image.asset(
                      'assets/icons/search_off.png',
                      height: 24,
                      width: 24,
                      color: AppColors.lightBackground,
                    ),
                  ),
                ),
                fillColor: AppColors.darkBackground,
                border: border,
                enabledBorder: border,
                focusedBorder: border.copyWith(
                  borderSide: const BorderSide(
                    color: AppColors.darkTextPrimary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () => context.pop(),
              child: Image.asset(
                'assets/icons/plus.png',
                height: 22,
                width: 22,
                color: AppColors.lightBackground,
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            GestureDetector(
              onTap: () => _showLayoutOptions(context),
              child: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.darkTextDisabled,
                ),
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  'assets/icons/compact_grid.png',
                  height: 16,
                  width: 16,
                  color: AppColors.lightBackground,
                ),
              ),
            ),
            SizedBox(width: 8),
            Container(
              height: 36,
              // width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.darkTextDisabled,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 22,
                    color: AppColors.lightBackground,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Favourites',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Container(
              height: 36,
              // width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.darkTextDisabled,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Text(
                  'Created by you',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Your saved Pins',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Builder(
            builder: (context) {
              if (state.isLoading && state.media.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.error != null && state.media.isEmpty) {
                AppLogger.logError('PinsTabScreen: Error loading pins', Exception(state.error));
                return Center(child: Text('Error: ${state.error}'));
              }

              final mediaList = state.media;
              AppLogger.logDebug('PinsTabScreen: Displaying ${mediaList.length} pins');

              if (mediaList.isEmpty) {
                return const Center(
                  child: Text(
                    "You haven't saved any pins yet.",
                    style: TextStyle(color: AppColors.lightTextSecondary),
                  ),
                );
              }

              return SavedMasonryGrid(
                mediaList: mediaList,
              );
            },
          ),
        ),
      ],
    );
  }
}
