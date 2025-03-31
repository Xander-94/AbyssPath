import 'package:flutter/material.dart'; // 导入Flutter基础库

class AppLoading extends StatelessWidget { // 通用加载指示器组件
  final Color? color; // 颜色
  final double size; // 大小
  final double strokeWidth; // 线条宽度
  final String? message; // 加载提示文本

  const AppLoading({ // 构造函数
    super.key,
    this.color,
    this.size = 40,
    this.strokeWidth = 4,
    this.message,
  });

  @override
  Widget build(BuildContext context) => Center( // 构建方法
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                strokeWidth: strokeWidth,
                valueColor: AlwaysStoppedAnimation<Color>(
                  color ?? Theme.of(context).primaryColor,
                ),
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      );
} 