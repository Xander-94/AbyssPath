import 'package:flutter/material.dart'; // 导入Flutter基础库
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 导入Riverpod
import '../../../../core/services/supabase_service.dart'; // 导入Supabase服务

class ForgotPasswordPage extends ConsumerStatefulWidget { // 忘记密码页面
  const ForgotPasswordPage({super.key}); // 构造函数

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState(); // 创建状态
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> { // 忘记密码页面状态
  final _formKey = GlobalKey<FormState>(); // 表单Key
  final _emailController = TextEditingController(); // 邮箱控制器
  bool _isLoading = false; // 加载状态
  bool _isSent = false; // 是否已发送

  @override
  void dispose() { // 释放资源
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async { // 重置密码方法
    if (!_formKey.currentState!.validate()) return; // 验证表单

    setState(() => _isLoading = true); // 设置加载状态

    try {
      await SupabaseService.auth.resetPasswordForEmail( // 发送重置密码邮件
        _emailController.text.trim(),
      );
      if (mounted) { // 如果组件还在树中
        setState(() => _isSent = true); // 设置已发送状态
      }
    } catch (e) {
      if (mounted) { // 如果组件还在树中
        ScaffoldMessenger.of(context).showSnackBar( // 显示错误提示
          SnackBar(content: Text('发送失败：$e')),
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
          title: const Text('忘记密码'), // 标题
        ),
        body: Padding( // 内边距
          padding: const EdgeInsets.all(16),
          child: _isSent // 根据状态显示不同内容
              ? Column( // 已发送状态
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon( // 成功图标
                      Icons.check_circle_outline,
                      size: 64,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    const Text( // 提示文本
                      '重置密码邮件已发送',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text( // 说明文本
                      '请检查您的邮箱并按照邮件中的说明重置密码',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox( // 返回按钮
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('返回登录'),
                      ),
                    ),
                  ],
                )
              : Form( // 未发送状态
                  key: _formKey,
                  child: Column( // 列布局
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text( // 提示文本
                        '请输入您的邮箱地址',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text( // 说明文本
                        '我们将向您的邮箱发送重置密码的链接',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextFormField( // 邮箱输入框
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: '邮箱',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入邮箱';
                          }
                          if (!value.contains('@')) {
                            return '请输入有效的邮箱';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox( // 发送按钮
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _resetPassword,
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text('发送重置链接'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton( // 返回登录按钮
                        onPressed: () => Navigator.pop(context),
                        child: const Text('返回登录'),
                      ),
                    ],
                  ),
                ),
        ),
      );
} 