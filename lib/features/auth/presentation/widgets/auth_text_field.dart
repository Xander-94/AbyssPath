import 'package:flutter/material.dart'; // 导入Flutter基础包

class AuthTextField extends StatelessWidget { // 认证文本输入框组件
  final String label; // 标签文本
  final String? hint; // 提示文本
  final bool isPassword; // 是否是密码输入框
  final TextEditingController controller; // 控制器
  final String? Function(String?)? validator; // 验证器
  final TextInputType? keyboardType; // 键盘类型
  final VoidCallback? onEditingComplete; // 编辑完成回调

  const AuthTextField({ // 构造函数
    super.key,
    required this.label,
    this.hint,
    this.isPassword = false,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) { // 构建UI
    return Padding( // 添加内边距
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField( // 文本表单字段
        controller: controller, // 控制器
        obscureText: isPassword, // 是否隐藏文本
        validator: validator, // 验证器
        keyboardType: keyboardType, // 键盘类型
        onEditingComplete: onEditingComplete, // 编辑完成回调
        decoration: InputDecoration( // 装饰
          labelText: label, // 标签文本
          hintText: hint, // 提示文本
          filled: true, // 填充背景
          fillColor: Colors.grey[100], // 填充颜色
          border: OutlineInputBorder( // 边框
            borderRadius: BorderRadius.circular(12), // 圆角
            borderSide: BorderSide.none, // 无边框
          ),
          enabledBorder: OutlineInputBorder( // 启用状态边框
            borderRadius: BorderRadius.circular(12), // 圆角
            borderSide: BorderSide.none, // 无边框
          ),
          focusedBorder: OutlineInputBorder( // 聚焦状态边框
            borderRadius: BorderRadius.circular(12), // 圆角
            borderSide: BorderSide( // 边框样式
              color: Theme.of(context).primaryColor, // 使用主题色
              width: 1.5, // 边框宽度
            ),
          ),
          errorBorder: OutlineInputBorder( // 错误状态边框
            borderRadius: BorderRadius.circular(12), // 圆角
            borderSide: BorderSide( // 边框样式
              color: Theme.of(context).colorScheme.error, // 使用错误色
              width: 1.5, // 边框宽度
            ),
          ),
        ),
      ),
    );
  }
} 