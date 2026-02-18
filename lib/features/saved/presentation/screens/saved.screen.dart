import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/auth/providers/auth_provider.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/saved/presentation/widgets/boards_tab_screen.dart';
import 'package:pinterest_clone/features/saved/presentation/widgets/pins_tab_screen.dart';

class SavedScreen extends ConsumerStatefulWidget {
  const SavedScreen({super.key});

  @override
  ConsumerState<SavedScreen> createState() => _ConsumerSavedScreenState();
}

class _ConsumerSavedScreenState extends ConsumerState<SavedScreen> {
  final List<String> _categories = ['Pins', 'Boards', 'Collages'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _categories.length,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.darkTextDisabled,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(300),
                        child: CachedNetworkImage(
                          imageUrl: ref.watch(userProvider)?.imageUrl ?? '',
                          errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                            color: AppColors.lightBackground,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBar(
                        isScrollable: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        indicatorColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                        indicatorWeight: 3,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                        unselectedLabelColor: AppColors.darkTextSecondary,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        dividerColor: Colors.transparent,
                        tabAlignment: TabAlignment.start,
                        tabs: _categories
                            .map((category) => Tab(text: category))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TabBarView(
                    children: [
                      PinsTabScreen(),
                      BoardsTabScreen(),
                      _buildContentPlaceholder('Collages'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentPlaceholder(String title) {
    return Center(
      child: Text(
        '$title Content',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.darkTextSecondary,
        ),
      ),
    );
  }
}
