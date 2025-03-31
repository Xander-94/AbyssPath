import 'package:flutter/material.dart'; // 导入Flutter基础包

class AuthButton extends StatelessWidget { // 认证按钮组件
  final String text; // 按钮文本
  final VoidCallback onPressed; // 点击回调
  final bool isLoading; // 是否加载中
  final bool isOutlined; // 是否使用轮廓样式

  const AuthButton({ // 构造函数
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) { // 构建UI
    return SizedBox( // 固定大小的容器
      width: double.infinity, // 宽度铺满
      height: 50, // 高度
      child: isOutlined // 根据是否使用轮廓样式选择按钮类型
          ? OutlinedButton( // 轮廓按钮
              onPressed: isLoading ? null : onPressed, // 点击回调
              style: OutlinedButton.styleFrom( // 按钮样式
                shape: RoundedRectangleBorder( // 形状
                  borderRadius: BorderRadius.circular(12), // 圆角
                ),
                side: BorderSide( // 边框
                  color: Theme.of(context).primaryColor, // 使用主题色
                  width: 1.5, // 边框宽度
                ),
              ),
              child: _buildChild(context), // 构建子组件
            )
          : ElevatedButton( // 凸起按钮
              onPressed: isLoading ? null : onPressed, // 点击回调
              style: ElevatedButton.styleFrom( // 按钮样式
                shape: RoundedRectangleBorder( // 形状
                  borderRadius: BorderRadius.circular(12), // 圆角
                ),
                elevation: 0, // 无阴影
                backgroundColor: Theme.of(context).primaryColor, // 背景色使用主题色
                foregroundColor: Colors.white, // 前景色为白色
              ),
              child: _buildChild(context), // 构建子组件
            ),
    );
  }

  Widget _buildChild(BuildContext context) { // 构建子组件
    return isLoading // 根据是否加载中显示不同内容
        ? SizedBox( // 加载中显示加载指示器
            height: 20,
            width: 20,
            child: CircularProgressIndicator( // 圆形进度指示器
              strokeWidth: 2, // 线条宽度
              valueColor: AlwaysStoppedAnimation<Color>( // 颜色
                isOutlined // 根据是否使用轮廓样式选择颜色
                    ? Theme.of(context).primaryColor // 主题色
                    : Colors.white, // 白色
              ),
            ),
          )
        : Text( // 显示文本
            text,
            style: TextStyle( // 文本样式
              fontSize: 16, // 字号
              fontWeight: FontWeight.w600, // 字重
            ),
          );
  }
} 