import '../../domain/entities/user.dart'; // 导入用户实体
import '../../domain/repositories/auth_repository.dart'; // 导入认证仓库接口
import '../datasources/auth_remote_data_source.dart'; // 导入认证远程数据源

class AuthRepositoryImpl implements AuthRepository { // 认证仓库实现
  final AuthRemoteDataSource _remoteDataSource; // 认证远程数据源

  AuthRepositoryImpl(this._remoteDataSource); // 构造函数

  @override
  Future<User> register({ // 注册
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      return await _remoteDataSource.register( // 调用远程数据源注册
        email: email,
        password: password,
        name: name,
      );
    } catch (e) {
      throw Exception('注册失败：${e.toString()}'); // 抛出异常
    }
  }

  @override
  Future<User> login({ // 登录
    required String email,
    required String password,
  }) async {
    try {
      return await _remoteDataSource.login( // 调用远程数据源登录
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('登录失败：${e.toString()}'); // 抛出异常
    }
  }

  @override
  Future<void> logout() async { // 登出
    try {
      await _remoteDataSource.logout(); // 调用远程数据源登出
    } catch (e) {
      throw Exception('登出失败：${e.toString()}'); // 抛出异常
    }
  }

  @override
  Future<void> resetPassword({ // 重置密码
    required String email,
  }) async {
    try {
      await _remoteDataSource.resetPassword( // 调用远程数据源重置密码
        email: email,
      );
    } catch (e) {
      throw Exception('重置密码失败：${e.toString()}'); // 抛出异常
    }
  }

  @override
  Future<void> updatePassword({ // 更新密码
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.updatePassword( // 调用远程数据源更新密码
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      throw Exception('更新密码失败：${e.toString()}'); // 抛出异常
    }
  }

  @override
  Future<void> verifyEmail({ // 验证邮箱
    required String token,
  }) async {
    try {
      await _remoteDataSource.verifyEmail( // 调用远程数据源验证邮箱
        token: token,
      );
    } catch (e) {
      throw Exception('验证邮箱失败：${e.toString()}'); // 抛出异常
    }
  }

  @override
  Future<void> resendVerificationEmail() async { // 重新发送验证邮件
    try {
      await _remoteDataSource.resendVerificationEmail(); // 调用远程数据源重新发送验证邮件
    } catch (e) {
      throw Exception('重新发送验证邮件失败：${e.toString()}'); // 抛出异常
    }
  }

  @override
  Future<User?> getCurrentUser() async { // 获取当前用户
    try {
      return await _remoteDataSource.getCurrentUser(); // 调用远程数据源获取当前用户
    } catch (e) {
      throw Exception('获取当前用户失败：${e.toString()}'); // 抛出异常
    }
  }

  @override
  Future<User> updateProfile({ // 更新用户资料
    String? name,
    String? avatar,
  }) async {
    try {
      return await _remoteDataSource.updateProfile( // 调用远程数据源更新用户资料
        name: name,
        avatar: avatar,
      );
    } catch (e) {
      throw Exception('更新用户资料失败：${e.toString()}'); // 抛出异常
    }
  }
} 