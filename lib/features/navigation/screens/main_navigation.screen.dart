import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/auth/providers/auth_provider.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/features/home/presentation/providers/home_provider.dart';
import 'package:pinterest_clone/features/home/presentation/screens/home_screen.dart';
import 'package:pinterest_clone/features/search/presentation/screens/search.screen.dart';
import 'package:pinterest_clone/features/create/presentation/screens/create.screen.dart';
import 'package:pinterest_clone/features/inbox/presentation/screens/inbox.screen.dart';
import 'package:pinterest_clone/features/saved/presentation/screens/saved.screen.dart';
import 'package:svg_flutter/svg.dart';
import 'package:pinterest_clone/features/create/presentation/widgets/create_modal.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const CreateScreen(),
    const InboxScreen(),
    const SavedScreen(),
  ];


  void _onItemTapped(int index) {
    if (index == 2) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => const CreateModal(),
      );
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.lightBackground,
        unselectedItemColor: AppColors.lightBackground,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24,
              height: 24,
              child: Transform.scale(
                scale: 0.85,
                child: SvgPicture.asset(
                  'assets/icons/home_off.svg',
                  color: Colors.white,
                ),
              ),
            ),
            activeIcon: Transform.scale(
              scale: 0.9,
              child: SvgPicture.asset(
                'assets/icons/home_on.svg',
                width: 24,
                height: 24,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                'assets/icons/search_off.png',
                color: Colors.white,
              ),
            ),
            activeIcon: Transform.scale(
              scale: 0.8,
              child: Image.asset(
                'assets/icons/search_on.png',
                width: 24,
                height: 24,
                color: Colors.white,
              ),
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Transform.scale(
              scale: 0.8,
              child: Image.asset(
                'assets/icons/plus.png',
                width: 24,
                height: 24,
                color: Colors.white,
              ),
            ),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Transform.scale(
              scale: 0.8,
              child: Image.asset(
                'assets/icons/inbox_off.png',
                width: 24,
                height: 24,
                color: Colors.white,
              ),
            ),
            activeIcon: Transform.scale(
              scale: 0.8,
              child: Image.asset(
                'assets/icons/inbox_on.png',
                width: 24,
                height: 24,
                color: Colors.white,
              ),
            ),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Consumer(
              builder: (context, ref, child) {
                final user = ref.watch(userProvider);
                if (user?.imageUrl != null) {
                  return CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(300),
                        child: CachedNetworkImage(imageUrl: user!.imageUrl!),
                      ),
                    ),
                  );
                }
                return const Icon(Icons.person, size: 24);
              },
            ),
            activeIcon: Consumer(
              builder: (context, ref, child) {
                final user = ref.watch(userProvider);
                if (user?.imageUrl != null) {
                  return CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(300),
                            child: CachedNetworkImage(
                              imageUrl: user!.imageUrl!,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const Icon(Icons.person, size: 24);
              },
            ),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}
