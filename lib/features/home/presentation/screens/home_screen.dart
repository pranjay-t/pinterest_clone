import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/core/common/pinterest_refresh_indicator.dart';
import 'package:pinterest_clone/features/home/presentation/providers/home_provider.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/board_tab_content.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/masonry_media_grid.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pinterest_clone/features/saved/data/models/local_board_model.dart';
import 'package:pinterest_clone/features/saved/presentation/providers/saved_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(boardsProvider.notifier).getBoards();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      final homeState = ref.read(homeProvider);
      if (!homeState.isMoreLoading && homeState.hasMore) {
        ref.read(homeProvider.notifier).fetchMorePhotos();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final boardsState = ref.watch(boardsProvider);
    final theme = Theme.of(context);

    final List<dynamic> tabs = ['For You', ...boardsState.boards];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              TabBar(
                isScrollable: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                indicatorColor: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: theme.brightness == Brightness.dark
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
                tabs: tabs.map((item) {
                  final title =
                      item is String ? item : (item as LocalBoardModel).name;
                  return Tab(text: title);
                }).toList(),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  children: tabs.map((item) {
                    if (item == 'For You') {
                      return PinterestRefreshIndicator(
                        onRefresh:
                            () => ref.read(homeProvider.notifier).refresh(),
                        child:
                            homeState.isLoading && homeState.photos.isEmpty
                                ? _buildLoadingShimmer()
                                : homeState.error != null &&
                                        homeState.photos.isEmpty
                                    ? _buildErrorView(homeState.error!)
                                    : MasonryMediaGrid(
                                        items: homeState.photos,
                                        scrollController: _scrollController,
                                      ),
                      );
                    } else {
                      return BoardTabContent(
                        board: item as LocalBoardModel,
                      );
                    }
                  }).toList(),
                ),
              ),
              if (homeState.isMoreLoading && _selectedIndex == 0)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkTextTertiary,
      highlightColor: AppColors.darkTextSecondary.withAlpha(190),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            height: (index % 2 == 0 ? 200 : 300).toDouble(),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(error, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton( // Retry logic could vary per tab, but for Home it is clear
            onPressed: () => ref.read(homeProvider.notifier).refresh(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

