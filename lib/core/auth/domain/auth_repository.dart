import 'package:pinterest_clone/core/auth/domain/user.dart';
abstract class AuthRepository {
  Future<void> signOut();
  Future<User?> getCurrentUser();
}
