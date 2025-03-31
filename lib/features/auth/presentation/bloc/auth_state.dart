import 'package:freezed_annotation/freezed_annotation.dart'; // 导入freezed注解
import '../../domain/entities/user.dart'; // 导入用户实体

part 'auth_state.freezed.dart'; // 生成freezed代码

@freezed // 使用freezed注解
class AuthState with _$AuthState { // 认证状态类
  const factory AuthState.initial() = _Initial; // 初始状态
  const factory AuthState.loading() = _Loading; // 加载状态
  const factory AuthState.authenticated(User user) = _Authenticated; // 已认证状态
  const factory AuthState.unauthenticated() = _Unauthenticated; // 未认证状态
  const factory AuthState.error(String message) = _Error; // 错误状态
} 