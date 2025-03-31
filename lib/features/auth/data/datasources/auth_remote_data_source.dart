import 'package:supabase_flutter/supabase_flutter.dart' as supabase; // 导入Supabase
import '../../domain/entities/user.dart' as domain; // 导入用户实体

class AuthRemoteDataSource { // 认证远程数据源
  final supabase.SupabaseClient _client; // Supabase客户端

  AuthRemoteDataSource({supabase.SupabaseClient? client}) // 构造函数
      : _client = client ?? supabase.Supabase.instance.client; // 初始化Supabase客户端

  Future<domain.User> register({ // 注册方法
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final response = await _client.auth.signUp( // 调用Supabase注册
        email: email,
        password: password,
        data: {'name': name}, // 用户元数据
      );
      if (response.user == null) { // 如果用户为空
        throw Exception('注册失败'); // 抛出异常
      }
      return domain.User.fromJson(response.user!.toJson()); // 返回用户实体
    } catch (e) { // 如果发生错误
      throw Exception('注册失败：${e.toString()}'); // 抛出异常
    }
  }

  Future<domain.User> login({ // 登录方法
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword( // 调用Supabase登录
        email: email,
        password: password,
      );
      if (response.user == null) { // 如果用户为空
        throw Exception('登录失败'); // 抛出异常
      }
      return domain.User.fromJson(response.user!.toJson()); // 返回用户实体
    } catch (e) { // 如果发生错误
      throw Exception('登录失败：${e.toString()}'); // 抛出异常
    }
  }

  Future<void> logout() async { // 登出方法
    try {
      await _client.auth.signOut(); // 调用Supabase登出
    } catch (e) { // 如果发生错误
      throw Exception('登出失败：${e.toString()}'); // 抛出异常
    }
  }

  Future<void> resetPassword({ // 重置密码方法
    required String email,
  }) async {
    try {
      await _client.auth.resetPasswordForEmail( // 调用Supabase重置密码
        email,
      );
    } catch (e) { // 如果发生错误
      throw Exception('重置密码失败：${e.toString()}'); // 抛出异常
    }
  }

  Future<void> updatePassword({ // 更新密码方法
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _client.auth.updateUser( // 调用Supabase更新密码
        supabase.UserAttributes(
          password: newPassword,
        ),
      );
    } catch (e) { // 如果发生错误
      throw Exception('更新密码失败：${e.toString()}'); // 抛出异常
    }
  }

  Future<void> verifyEmail({ // 验证邮箱方法
    required String token,
  }) async {
    try {
      await _client.auth.verifyOTP( // 调用Supabase验证邮箱
        token: token,
        type: supabase.OtpType.signup,
      );
    } catch (e) { // 如果发生错误
      throw Exception('验证邮箱失败：${e.toString()}'); // 抛出异常
    }
  }

  Future<void> resendVerificationEmail() async { // 重新发送验证邮件方法
    try {
      await _client.auth.resend( // 调用Supabase重新发送验证邮件
        type: supabase.OtpType.signup,
      );
    } catch (e) { // 如果发生错误
      throw Exception('重新发送验证邮件失败：${e.toString()}'); // 抛出异常
    }
  }

  Future<domain.User?> getCurrentUser() async { // 获取当前用户方法
    try {
      final user = _client.auth.currentUser; // 获取当前用户
      if (user == null) { // 如果用户为空
        return null; // 返回空
      }
      return domain.User.fromJson(user.toJson()); // 返回用户实体
    } catch (e) { // 如果发生错误
      throw Exception('获取当前用户失败：${e.toString()}'); // 抛出异常
    }
  }

  Future<domain.User> updateProfile({ // 更新用户资料方法
    String? name,
    String? avatar,
  }) async {
    try {
      final response = await _client.auth.updateUser( // 调用Supabase更新用户资料
        supabase.UserAttributes(
          data: {
            'name': name,
            'avatar': avatar,
          },
        ),
      );
      if (response.user == null) { // 如果用户为空
        throw Exception('更新用户资料失败'); // 抛出异常
      }
      return domain.User.fromJson(response.user!.toJson()); // 返回用户实体
    } catch (e) { // 如果发生错误
      throw Exception('更新用户资料失败：${e.toString()}'); // 抛出异常
    }
  }
} 