import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../../features/auth/data/models/user_model.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(null) {
    // 初始化时检查用户状态
    final user = SupabaseService.auth.currentUser;
    if (user != null) {
      final now = DateTime.now();
      state = UserModel(
        id: user.id,
        email: user.email ?? '',
        createdAt: DateTime.parse(user.createdAt),
        updatedAt: user.updatedAt != null ? DateTime.parse(user.updatedAt!) : now,
      );
    }

    // 监听认证状态变化
    SupabaseService.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        final user = data.session?.user;
        if (user != null) {
          final now = DateTime.now();
          state = UserModel(
            id: user.id,
            email: user.email ?? '',
            createdAt: DateTime.parse(user.createdAt),
            updatedAt: user.updatedAt != null ? DateTime.parse(user.updatedAt!) : now,
          );
        }
      } else if (data.event == AuthChangeEvent.signedOut) {
        state = null;
      }
    });
  }

  // 更新用户信息
  void updateUser(UserModel user) {
    state = user;
  }

  // 清除用户信息
  void clearUser() {
    state = null;
  }
} 