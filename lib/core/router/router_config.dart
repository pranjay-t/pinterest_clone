import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:pinterest_clone/features/login/presentation/screens/login.screen.dart';
import 'package:pinterest_clone/features/login/presentation/screens/login_password.screen.dart';
import 'package:pinterest_clone/features/navigation/screens/main_navigation.screen.dart';

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
    ],
  );
}

