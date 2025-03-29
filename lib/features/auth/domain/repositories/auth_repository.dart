import '../entities/user.dart'; // 导入用户实体

abstract class AuthRepository { // 认证仓库接口
  // 用户注册
  Future<User> register({
    required String email,
    required String password,
    String? name,
  });

  // 用户登录
  Future<User> login({
    required String email,
    required String password,
  });

  // 用户登出
  Future<void> logout();

  // 重置密码
  Future<void> resetPassword({
    required String email,
  });

  // 更新密码
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  });

  // 验证邮箱
  Future<void> verifyEmail({
    required String token,
  });

  // 重新发送验证邮件
  Future<void> resendVerificationEmail();

  // 获取当前用户
  Future<User?> getCurrentUser();

  // 更新用户资料
  Future<User> updateProfile({
    String? name,
    String? avatar,
  });
} 