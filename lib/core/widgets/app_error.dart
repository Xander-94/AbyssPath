import 'package:flutter/material.dart'; // 导入Flutter基础库
import 'app_button.dart'; // 导入通用按钮组件

class AppError extends StatelessWidget { // 通用错误提示组件
  final String? message; // 错误信息
  final VoidCallback? onRetry; // 重试回调
  final String? retryText; // 重试按钮文本
  final IconData? icon; // 图标
  final double? iconSize; // 图标大小
  final Color? iconColor; // 图标颜色
  final TextStyle? messageStyle; // 错误信息样式

  const AppError({ // 构造函数
    super.key,
    this.message,
    this.onRetry,
    this.retryText,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.messageStyle,
  });

  @override
  Widget build(BuildContext context) => Center( // 构建方法
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon ?? Icons.error_outline,
                size: iconSize ?? 64,
                color: iconColor ?? Theme.of(context).colorScheme.error,
              ),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message!,
                  style: messageStyle ?? Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                AppButton(
                  onPressed: onRetry,
                  child: Text(retryText ?? '重试'),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
                    minimumSize: MaterialStateProperty.all(const Size(120, 40)),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
} 