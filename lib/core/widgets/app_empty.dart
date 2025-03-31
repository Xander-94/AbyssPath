import 'package:flutter/material.dart'; // 导入Flutter基础库
import 'app_button.dart'; // 导入通用按钮组件

class AppEmpty extends StatelessWidget { // 通用空状态组件
  final String? message; // 提示信息
  final VoidCallback? onAction; // 操作回调
  final String? actionText; // 操作按钮文本
  final IconData? icon; // 图标
  final double? iconSize; // 图标大小
  final Color? iconColor; // 图标颜色
  final TextStyle? messageStyle; // 提示信息样式

  const AppEmpty({ // 构造函数
    super.key,
    this.message,
    this.onAction,
    this.actionText,
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
                icon ?? Icons.inbox_outlined,
                size: iconSize ?? 64,
                color: iconColor ?? Theme.of(context).disabledColor,
              ),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message!,
                  style: messageStyle ?? Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
              if (onAction != null) ...[
                const SizedBox(height: 16),
                AppButton(
                  onPressed: onAction,
                  child: Text(actionText ?? '刷新'),
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