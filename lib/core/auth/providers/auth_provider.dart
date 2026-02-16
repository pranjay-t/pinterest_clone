import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/auth/data/clerk_auth_repository.dart';
import 'package:pinterest_clone/core/auth/domain/auth_repository.dart';
import 'package:pinterest_clone/core/auth/domain/user.dart';



final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return ClerkAuthRepository();
});

class UserNotifier extends Notifier<User?> {
  @override
  User? build() {
    return null;
  }

  Future<void> refresh() async {
    final repo = ref.read(authRepositoryProvider);
    state = await repo.getCurrentUser();
    print('User refreshed: ${state?.email}');
  }
}

final userProvider = NotifierProvider<UserNotifier, User?>(UserNotifier.new);

final authStateProvider = StreamProvider<bool>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});
