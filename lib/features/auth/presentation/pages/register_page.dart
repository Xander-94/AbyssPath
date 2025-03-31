import 'package:flutter/material.dart'; // 导入Flutter基础库
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 导入Riverpod
import 'package:go_router/go_router.dart';
import '../../../../core/services/supabase_service.dart'; // 导入Supabase服务
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/auth_notifier.dart';

class RegisterPage extends ConsumerStatefulWidget { // 注册页面
  const RegisterPage({super.key}); // 构造函数

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState(); // 创建状态
}

class _RegisterPageState extends ConsumerState<RegisterPage> { // 注册页面状态
  final _formKey = GlobalKey<FormState>(); // 表单键
  final _emailController = TextEditingController(); // 邮箱控制器
  final _passwordController = TextEditingController(); // 密码控制器
  final _confirmPasswordController = TextEditingController(); // 确认密码控制器
  bool _isLoading = false; // 加载状态

  @override
  void dispose() { // 释放资源
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async { // 注册方法
    if (!_formKey.currentState!.validate()) return; // 验证表单

    setState(() => _isLoading = true); // 设置加载状态

    try {
      await ref.read(authNotifierProvider.notifier).register( // 使用邮箱密码注册
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) { // 如果组件还在树中
        ScaffoldMessenger.of(context).showSnackBar( // 显示成功提示
          const SnackBar(content: Text('注册成功，请登录')),
        );
        context.go('/login'); // 导航到登录页
      }
    } catch (e) {
      if (mounted) { // 如果组件还在树中
        ScaffoldMessenger.of(context).showSnackBar( // 显示错误提示
          SnackBar(content: Text('注册失败：$e')),
        );
      }
    } finally {
      if (mounted) { // 如果组件还在树中
        setState(() => _isLoading = false); // 设置加载状态
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold( // 构建方法
        appBar: AppBar( // 应用栏
          title: const Text('注册'), // 标题
        ),
        body: Form( // 表单
          key: _formKey,
          child: ListView( // 列表布局
            padding: const EdgeInsets.all(16.0),
            children: [
              AppTextField(
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
              const SizedBox(height: 16),
              AppTextField(
                controller: _passwordController,
                labelText: '密码',
                hintText: '请输入密码',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入密码';
                  }
                  if (value.length < 6) {
                    return '密码至少6位';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _confirmPasswordController,
                labelText: '确认密码',
                hintText: '请再次输入密码',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请确认密码';
                  }
                  if (value != _passwordController.text) {
                    return '两次输入的密码不一致';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              AppButton(
                onPressed: _isLoading ? null : _register,
                isLoading: _isLoading,
                child: const Text('注册'),
              ),
              const SizedBox(height: 16),
              Row( // 登录链接
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('已有账号？'),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('立即登录'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}