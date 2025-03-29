import '../entities/user.dart'; // 导入用户实体
import '../repositories/auth_repository.dart'; // 导入认证仓库接口

class RegisterUseCase { // 注册用例
  final AuthRepository repository; // 认证仓库

  RegisterUseCase(this.repository); // 构造函数

  Future<User> call({ // 执行注册
    required String email,
    required String password,
    String? name,
  }) {
    return repository.register( // 调用仓库注册方法
      email: email,
      password: password,
      name: name,
    );
  }
}

class LoginUseCase { // 登录用例
  final AuthRepository repository; // 认证仓库

  LoginUseCase(this.repository); // 构造函数

  Future<User> call({ // 执行登录
    required String email,
    required String password,
  }) {
    return repository.login( // 调用仓库登录方法
      email: email,
      password: password,
    );
  }
}

class LogoutUseCase { // 登出用例
  final AuthRepository repository; // 认证仓库

  LogoutUseCase(this.repository); // 构造函数

  Future<void> call() { // 执行登出
    return repository.logout(); // 调用仓库登出方法
  }
}

class ResetPasswordUseCase { // 重置密码用例
  final AuthRepository repository; // 认证仓库

  ResetPasswordUseCase(this.repository); // 构造函数

  Future<void> call({ // 执行重置密码
    required String email,
  }) {
    return repository.resetPassword( // 调用仓库重置密码方法
      email: email,
    );
  }
}

class UpdatePasswordUseCase { // 更新密码用例
  final AuthRepository repository; // 认证仓库

  UpdatePasswordUseCase(this.repository); // 构造函数

  Future<void> call({ // 执行更新密码
    required String currentPassword,
    required String newPassword,
  }) {
    return repository.updatePassword( // 调用仓库更新密码方法
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}

class VerifyEmailUseCase { // 验证邮箱用例
  final AuthRepository repository; // 认证仓库

  VerifyEmailUseCase(this.repository); // 构造函数

  Future<void> call({ // 执行验证邮箱
    required String token,
  }) {
    return repository.verifyEmail( // 调用仓库验证邮箱方法
      token: token,
    );
  }
}

class ResendVerificationEmailUseCase { // 重新发送验证邮件用例
  final AuthRepository repository; // 认证仓库

  ResendVerificationEmailUseCase(this.repository); // 构造函数

  Future<void> call() { // 执行重新发送验证邮件
    return repository.resendVerificationEmail(); // 调用仓库重新发送验证邮件方法
  }
}

class GetCurrentUserUseCase { // 获取当前用户用例
  final AuthRepository repository; // 认证仓库

  GetCurrentUserUseCase(this.repository); // 构造函数

  Future<User?> call() { // 执行获取当前用户
    return repository.getCurrentUser(); // 调用仓库获取当前用户方法
  }
}

class UpdateProfileUseCase { // 更新用户资料用例
  final AuthRepository repository; // 认证仓库

  UpdateProfileUseCase(this.repository); // 构造函数

  Future<User> call({ // 执行更新用户资料
    String? name,
    String? avatar,
  }) {
    return repository.updateProfile( // 调用仓库更新用户资料方法
      name: name,
      avatar: avatar,
    );
  }
} 