import 'package:pinterest_clone/core/auth/domain/user.dart';
abstract class AuthRepository {
  Future<void> signOut();
  Stream<bool> get authStateChanges;
  Future<User?> getCurrentUser();
}
