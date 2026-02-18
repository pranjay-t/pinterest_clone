import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/saved/presentation/providers/layout_provider.dart';

class SelectLayoutBottomSheet extends ConsumerWidget {
  const SelectLayoutBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLayout = ref.watch(pinLayoutProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Feed layout options',
            style: TextStyle(
              color: AppColors.lightBackground,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16),
          _buildLayoutOption(context, ref, 'Wide', PinLayout.wide, currentLayout),
          _buildLayoutOption(context, ref, 'Standard', PinLayout.standard, currentLayout),
          _buildLayoutOption(context, ref, 'Compact', PinLayout.compact, currentLayout),
          SizedBox(height: 24),
          Align(
            alignment: AlignmentGeometry.center,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.darkTextDisabled,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: AppColors.lightBackground,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLayoutOption(BuildContext context, WidgetRef ref, String title, PinLayout layout, PinLayout currentLayout) {
    bool isSelected = layout == currentLayout;
    return GestureDetector(
      onTap: () {
        ref.read(pinLayoutProvider.notifier).setLayout(layout);
        // Add a small delay for visual feedback before closing
        Future.delayed(const Duration(milliseconds: 150), () {
          if (context.mounted) context.pop();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkTextDisabled : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.lightBackground,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isSelected)
              Icon(Icons.check, color: AppColors.lightBackground, size: 24),
          ],
        ),
      ),
    );
  }
}
