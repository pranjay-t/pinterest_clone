import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';

class SelectLayoutBottomSheet extends StatelessWidget {
  const SelectLayoutBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    
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
          SizedBox(height: 4),
          _buildLayoutOption('Wide'),
          _buildLayoutOption('Standard'),
          _buildLayoutOption('Compact', isSelected: true),
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
}

  Widget _buildLayoutOption(String title, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.lightBackground,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isSelected)
            Icon(Icons.check, color: AppColors.lightBackground, size: 28),
        ],
      ),
    );
  }
