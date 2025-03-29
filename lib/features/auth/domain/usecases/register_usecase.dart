import '../entities/user.dart'; // 导入用户实体
import '../repositories/auth_repository.dart'; // 导入认证仓库

class RegisterUseCase { // 注册用例
  final AuthRepository _repository; // 认证仓库

  RegisterUseCase(this._repository); // 构造函数

  Future<User> call({ // 调用方法
    required String email,
    required String password,
    String? name,
  }) async {
    // 验证邮箱格式
    if (!_isValidEmail(email)) {
      throw Exception('邮箱格式不正确');
    }

    // 验证密码强度
    if (!_isValidPassword(password)) {
      throw Exception('密码强度不足');
    }

    // 调用仓库注册方法
    return await _repository.register(
      email: email,
      password: password,
      name: name,
    );
  }

  bool _isValidEmail(String email) { // 验证邮箱格式
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPassword(String password) { // 验证密码强度
    // 密码至少8位，包含大小写字母和数字
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$').hasMatch(password);
  }
} 