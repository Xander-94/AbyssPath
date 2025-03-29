import 'package:supabase_flutter/supabase_flutter.dart' as supabase; // 导入Supabase客户端
import '../../domain/entities/user.dart' as domain; // 导入用户实体

class AuthRemoteDataSource { // 认证远程数据源
  final supabase.SupabaseClient _client; // Supabase客户端

  AuthRemoteDataSource(this._client); // 构造函数

  Future<domain.User> register({ // 注册
    required String email,
    required String password,
    String? name,
  }) async {
    final response = await _client.auth.signUp( // 调用Supabase注册
      email: email,
      password: password,
      data: {'name': name}, // 用户数据
    );
    return domain.User.fromJson(response.user!.toJson()); // 返回用户实体
  }

  Future<domain.User> login({ // 登录
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword( // 调用Supabase登录
      email: email,
      password: password,
    );
    return domain.User.fromJson(response.user!.toJson()); // 返回用户实体
  }

  Future<void> logout() async { // 登出
    await _client.auth.signOut(); // 调用Supabase登出
  }

  Future<void> resetPassword({ // 重置密码
    required String email,
  }) async {
    await _client.auth.resetPasswordForEmail(email); // 调用Supabase重置密码
  }

  Future<void> updatePassword({ // 更新密码
    required String currentPassword,
    required String newPassword,
  }) async {
    await _client.auth.updateUser( // 调用Supabase更新密码
      supabase.UserAttributes(
        password: newPassword,
      ),
    );
  }

  Future<void> verifyEmail({ // 验证邮箱
    required String token,
  }) async {
    await _client.auth.verifyOTP( // 调用Supabase验证邮箱
      token: token,
      type: supabase.OtpType.email,
    );
  }

  Future<void> resendVerificationEmail() async { // 重新发送验证邮件
    await _client.auth.resend( // 调用Supabase重新发送验证邮件
      type: supabase.OtpType.signup,
    );
  }

  Future<domain.User?> getCurrentUser() async { // 获取当前用户
    final user = _client.auth.currentUser; // 获取当前用户
    if (user == null) return null; // 如果没有用户返回null
    return domain.User.fromJson(user.toJson()); // 返回用户实体
  }

  Future<domain.User> updateProfile({ // 更新用户资料
    String? name,
    String? avatar,
  }) async {
    final response = await _client.auth.updateUser( // 调用Supabase更新用户资料
      supabase.UserAttributes(
        data: {
          'name': name,
          'avatar': avatar,
        },
      ),
    );
    return domain.User.fromJson(response.user!.toJson()); // 返回用户实体
  }
} 