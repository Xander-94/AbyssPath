import 'package:flutter/material.dart'; // 导入Flutter基础库
import 'package:go_router/go_router.dart'; // 导入GoRouter
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 导入Riverpod
import '../../features/auth/presentation/bloc/auth_notifier.dart'; // 导入认证状态管理器
import '../../features/auth/presentation/pages/login_page.dart'; // 导入登录页面
import '../../features/auth/presentation/pages/register_page.dart'; // 导入注册页面
import '../../features/auth/presentation/pages/forgot_password_page.dart'; // 导入忘记密码页面
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/learning_path/presentation/pages/path_list_page.dart';
import '../../features/learning_path/presentation/pages/path_detail_page.dart';
import '../../features/learning_path/presentation/pages/generate_path_page.dart';

final routerProvider = Provider<GoRouter>((ref) { // 路由提供者
  final authState = ref.watch(authNotifierProvider); // 获取认证状态

  return GoRouter( // 创建路由
    initialLocation: '/', // 修改初始路由为首页
    redirect: (context, state) { // 路由重定向
      final isLoggedIn = authState.maybeWhen( // 检查是否已登录
        authenticated: (_) => true,
        orElse: () => false,
      );

      final isAuthRoute = state.matchedLocation == '/login' || // 检查是否是认证路由
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password';

      if (!isLoggedIn && !isAuthRoute) { // 如果未登录且不是认证路由
        return '/login'; // 重定向到登录页面
      }

      if (isLoggedIn && isAuthRoute) { // 如果已登录且是认证路由
        return '/'; // 重定向到首页
      }

      return null; // 不重定向
    },
    routes: [ // 路由列表
      GoRoute( // 登录路由
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute( // 注册路由
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute( // 忘记密码路由
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/paths/generate',
        builder: (context, state) => const GeneratePathPage(),
      ),
      GoRoute(
        path: '/paths/:pathId',
        builder: (context, state) {
          final pathId = state.pathParameters['pathId']!;
          return PathDetailPage(pathId: pathId);
        },
      ),
    ],
  );
}); 