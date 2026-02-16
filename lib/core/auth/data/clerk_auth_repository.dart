import 'dart:async';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:pinterest_clone/core/auth/domain/auth_repository.dart';
import 'package:pinterest_clone/core/router/router_config.dart';
import 'package:pinterest_clone/core/auth/domain/user.dart';
import 'package:pinterest_clone/core/utils/app_logger.dart';

class ClerkAuthRepository implements AuthRepository {
  ClerkAuthRepository();

  @override
  Future<void> signOut() async {
    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      return ClerkAuth.of(context).signOut();
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    final context = rootNavigatorKey.currentContext;
    if (context == null) return null;

    try {
      final auth = ClerkAuth.of(context);
      final clerkUser = auth.user;
      if (clerkUser == null) return null;

      return User(
        id: clerkUser.id,
        email: clerkUser.email ?? 'N/A',
        firstName: clerkUser.firstName,
        lastName: clerkUser.lastName,
        imageUrl: clerkUser.imageUrl,
      );
    } catch (e) {
      AppLogger.logError('Error fetching current user: $e');
      return null;
    }
  }
}
