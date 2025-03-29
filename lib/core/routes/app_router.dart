import 'package:go_router/go_router.dart'; // 导入go_router包
import 'package:flutter/material.dart'; // 导入Flutter Material包

final router = GoRouter( // 路由配置
  initialLocation: '/', // 初始路由
  routes: [ // 路由列表
    GoRoute( // 首页路由
      path: '/',
      builder: (context, state) => const Scaffold(body: Center(child: Text('首页'))),
    ),
    GoRoute( // 登录页路由
      path: '/login',
      builder: (context, state) => const Scaffold(body: Center(child: Text('登录'))),
    ),
    GoRoute( // 注册页路由
      path: '/register',
      builder: (context, state) => const Scaffold(body: Center(child: Text('注册'))),
    ),
  ],
  errorBuilder: (context, state) => Scaffold( // 错误页面
    body: Center(child: Text('错误: ${state.error}')),
  ),
); 