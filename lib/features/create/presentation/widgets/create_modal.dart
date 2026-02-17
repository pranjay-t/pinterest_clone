import 'package:flutter/material.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class CreateModal extends StatelessWidget {
  const CreateModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        color: AppColors.darkCard,
      ),
      padding: const EdgeInsets.only(bottom: 40, top: 20),
      child: Stack(
        children: [
          Positioned(
            top: 2,
            left: 10,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, size: 32),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              const Text(
                'Start creating now',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOption(context, 'Pin', 'assets/icons/create_pin.png'),
                  SizedBox(width: 20),
                  _buildOption(
                    context,
                    'Collage',
                    'assets/icons/create_collage.png',
                  ),
                  SizedBox(width: 20),
                  _buildOption(
                    context,
                    'Board',
                    'assets/icons/create_board.png',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, String label, String assetPath) {
    return GestureDetector(
      onTap: () {
        context.pop();
        if (label == 'Board') {
          context.push('/create_board');
        }
      },
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Image.asset(
                assetPath,
                width: 40,
                height: 40,
                color: AppColors.lightTextDisabled,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
