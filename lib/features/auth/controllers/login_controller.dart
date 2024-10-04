import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yeneta_tutor/features/auth/repository/auth_repository.dart';

// Login controller provider
final loginControllerProvider = StateNotifierProvider<LoginController, AsyncValue<User?>>((ref) {
  return LoginController(ref);
});

class LoginController extends StateNotifier<AsyncValue<User?>> {
  final Ref _ref; // Corrected from Reader to Ref
  LoginController(this._ref) : super(const AsyncValue.data(null));

  // Function to handle login
  Future<void> login(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      final user = await _ref.read(authRepositoryProvider).login(email, password);
      if (user != null) {
        state = AsyncValue.data(user);
      } else {
        state = AsyncValue.error('Login failed', StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  // Function to handle logout
  void logout() async {
    await _ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(null);
  }
}

// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
