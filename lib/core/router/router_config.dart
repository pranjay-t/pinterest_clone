import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/presentation/screens/image_detail_screen.dart';
import 'package:pinterest_clone/features/login/presentation/screens/login.screen.dart';
import 'package:pinterest_clone/features/login/presentation/screens/login_password.screen.dart';
import 'package:pinterest_clone/features/navigation/screens/main_navigation.screen.dart';
import 'package:pinterest_clone/features/search/presentation/screens/search_input_screen.dart';
import 'package:pinterest_clone/features/search/presentation/screens/search_result_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(BuildContext context) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: ClerkAuth.of(context),
    redirect: (context, state) {
      final authState = ClerkAuth.of(context);
      final isSignedIn = authState.user != null;
      final isLoggingIn = state.uri.toString() == '/' ||
          state.uri.toString() == '/login_password';

      if (isSignedIn && isLoggingIn) {
        return '/home';
      }

      if (!isSignedIn && !isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/login_password',
        builder: (context, state) {
          final email = state.extra as String;
          return LoginPasswordScreen(email: email);
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: '/image_detail/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'];
          final photo = state.extra as PexelsPhoto?;

          return CustomTransitionPage(
            key: state.pageKey,
            child: ImageDetailScreen(
              imageId: id!,
              photo: photo,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.easeOut;
              var tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/search_input',
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: SearchInputScreen(),
          );
        },
      ),
      GoRoute(
        path: '/search_result/:query',
        builder: (context, state) {
          final query = state.pathParameters['query']!;
          return SearchResultScreen(query: query);
        },
      ),
    ],
  );
}

