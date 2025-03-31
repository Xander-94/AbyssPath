import 'package:flutter_riverpod/flutter_riverpod.dart'; // 导入Riverpod
import '../../domain/entities/user.dart'; // 导入用户实体
import '../../domain/repositories/auth_repository.dart'; // 导入认证仓库接口
import '../../data/repositories/auth_repository_impl.dart'; // 导入认证仓库实现
import '../../data/datasources/auth_remote_data_source.dart'; // 导入认证远程数据源
import 'auth_state.dart'; // 导入认证状态

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) => AuthRemoteDataSource()); // 创建认证远程数据源提供者

final authRepositoryProvider = Provider<AuthRepository>((ref) { // 创建认证仓库提供者
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider); // 获取认证远程数据源
  return AuthRepositoryImpl(remoteDataSource); // 返回认证仓库实现
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) { // 创建认证状态提供者
  final authRepository = ref.watch(authRepositoryProvider); // 获取认证仓库
  return AuthNotifier(authRepository); // 返回认证状态管理器
});

class AuthNotifier extends StateNotifier<AuthState> { // 认证状态管理器
  final AuthRepository _authRepository; // 认证仓库

  AuthNotifier(this._authRepository) : super(const AuthState.initial()) { // 构造函数
    _init(); // 初始化
  }

  Future<void> _init() async { // 初始化方法
    state = const AuthState.loading(); // 设置加载状态
    try {
      final user = await _authRepository.getCurrentUser(); // 获取当前用户
      if (user != null) { // 如果有用户
        state = AuthState.authenticated(user); // 设置已认证状态
      } else { // 如果没有用户
        state = const AuthState.unauthenticated(); // 设置未认证状态
      }
    } catch (e) { // 如果发生错误
      state = AuthState.error(e.toString()); // 设置错误状态
    }
  }

  Future<void> login({ // 登录方法
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading(); // 设置加载状态
    try {
      final user = await _authRepository.login( // 调用登录方法
        email: email,
        password: password,
      );
      state = AuthState.authenticated(user); // 设置已认证状态
    } catch (e) { // 如果发生错误
      state = AuthState.error(e.toString()); // 设置错误状态
    }
  }

  Future<void> register({ // 注册方法
    required String email,
    required String password,
    String? name,
  }) async {
    state = const AuthState.loading(); // 设置加载状态
    try {
      final user = await _authRepository.register( // 调用注册方法
        email: email,
        password: password,
        name: name,
      );
      state = AuthState.authenticated(user); // 设置已认证状态
    } catch (e) { // 如果发生错误
      state = AuthState.error(e.toString()); // 设置错误状态
    }
  }

  Future<void> logout() async { // 登出方法
    state = const AuthState.loading(); // 设置加载状态
    try {
      await _authRepository.logout(); // 调用登出方法
      state = const AuthState.unauthenticated(); // 设置未认证状态
    } catch (e) { // 如果发生错误
      state = AuthState.error(e.toString()); // 设置错误状态
    }
  }

  Future<void> resetPassword({ // 重置密码方法
    required String email,
  }) async {
    state = const AuthState.loading(); // 设置加载状态
    try {
      await _authRepository.resetPassword( // 调用重置密码方法
        email: email,
      );
      state = const AuthState.unauthenticated(); // 设置未认证状态
    } catch (e) { // 如果发生错误
      state = AuthState.error(e.toString()); // 设置错误状态
    }
  }

  Future<void> updatePassword({ // 更新密码方法
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AuthState.loading(); // 设置加载状态
    try {
      await _authRepository.updatePassword( // 调用更新密码方法
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      state = const AuthState.unauthenticated(); // 设置未认证状态
    } catch (e) { // 如果发生错误
      state = AuthState.error(e.toString()); // 设置错误状态
    }
  }

  Future<void> verifyEmail({ // 验证邮箱方法
    required String token,
  }) async {
    state = const AuthState.loading(); // 设置加载状态
    try {
      await _authRepository.verifyEmail( // 调用验证邮箱方法
        token: token,
      );
      state = const AuthState.unauthenticated(); // 设置未认证状态
    } catch (e) { // 如果发生错误
      state = AuthState.error(e.toString()); // 设置错误状态
    }
  }

  Future<void> resendVerificationEmail() async { // 重新发送验证邮件方法
    state = const AuthState.loading(); // 设置加载状态
    try {
      await _authRepository.resendVerificationEmail(); // 调用重新发送验证邮件方法
      state = const AuthState.unauthenticated(); // 设置未认证状态
    } catch (e) { // 如果发生错误
      state = AuthState.error(e.toString()); // 设置错误状态
    }
  }

  Future<void> updateProfile({ // 更新用户资料方法
    String? name,
    String? avatar,
  }) async {
    state = const AuthState.loading(); // 设置加载状态
    try {
      final user = await _authRepository.updateProfile( // 调用更新用户资料方法
        name: name,
        avatar: avatar,
      );
      state = AuthState.authenticated(user); // 设置已认证状态
    } catch (e) { // 如果发生错误
      state = AuthState.error(e.toString()); // 设置错误状态
    }
  }
} 