import 'package:flutter/material.dart'; // 导入Flutter基础库
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 导入Riverpod
import '../../../../core/widgets/app_button.dart'; // 导入通用按钮组件
import '../../../../core/widgets/app_text_field.dart'; // 导入通用输入框组件
import '../bloc/auth_notifier.dart'; // 导入认证状态管理器
import 'package:go_router/go_router.dart'; // 导入GoRouter
import '../../../../core/services/supabase_service.dart'; // 导入Supabase服务

class LoginPage extends ConsumerStatefulWidget { // 登录页面
  const LoginPage({super.key}); // 构造函数

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState(); // 创建状态
}

class _LoginPageState extends ConsumerState<LoginPage> { // 登录页面状态
  final _formKey = GlobalKey<FormState>(); // 表单Key
  final _emailController = TextEditingController(); // 邮箱控制器
  final _passwordController = TextEditingController(); // 密码控制器
  bool _obscurePassword = true; // 是否隐藏密码
  bool _loading = false; // 是否加载中

  @override
  void dispose() { // 销毁
    _emailController.dispose(); // 销毁邮箱控制器
    _passwordController.dispose(); // 销毁密码控制器
    super.dispose();
  }

  Future<void> _login() async { // 登录方法
    if (!_formKey.currentState!.validate()) return; // 验证表单

    setState(() => _loading = true); // 设置加载状态

    try {
      await ref.read(authNotifierProvider.notifier).login( // 调用登录方法
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) { // 如果组件还在树中
        context.go('/'); // 导航到主页
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar( // 显示错误提示
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _loading = false); // 重置加载状态
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold( // 构建方法
        appBar: AppBar(title: const Text('登录')), // 标题栏
        body: Form( // 表单
          key: _formKey,
          child: ListView( // 列表视图
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 32), // 顶部间距
              Text( // 欢迎文本
                '欢迎回来',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8), // 间距
              Text( // 提示文本
                '请登录您的账号',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32), // 间距
              AppTextField( // 邮箱输入框
                controller: _emailController,
                labelText: '邮箱',
                hintText: '请输入邮箱地址',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入邮箱';
                  }
                  if (!value.contains('@')) {
                    return '请输入有效的邮箱地址';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16), // 间距
              AppTextField( // 密码输入框
                controller: _passwordController,
                labelText: '密码',
                hintText: '请输入密码',
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入密码';
                  }
                  if (value.length < 6) {
                    return '密码长度不能小于6位';
                  }
                  return null;
                },
                suffixIcon: IconButton( // 显示/隐藏密码按钮
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
              const SizedBox(height: 16), // 间距
              Align( // 忘记密码按钮
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.push('/forgot-password'); // 导航到忘记密码页面
                  },
                  child: const Text('忘记密码？'),
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                onPressed: _loading ? null : _login,
                isLoading: _loading,
                child: const Text('登录'),
              ),
              const SizedBox(height: 16), // 间距
              Row( // 注册提示
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => context.go('/register'),
                    child: const Text('注册账号'),
                  ),
                  TextButton(
                    onPressed: () => context.go('/forgot-password'),
                    child: const Text('忘记密码？'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
} 