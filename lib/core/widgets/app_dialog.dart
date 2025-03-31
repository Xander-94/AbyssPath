import 'package:flutter/material.dart'; // 导入Flutter基础库
import 'app_button.dart'; // 导入通用按钮组件

class AppDialog extends StatelessWidget { // 通用对话框组件
  final String? title; // 标题
  final String? message; // 消息
  final String? confirmText; // 确认按钮文本
  final String? cancelText; // 取消按钮文本
  final VoidCallback? onConfirm; // 确认回调
  final VoidCallback? onCancel; // 取消回调
  final bool showCancel; // 是否显示取消按钮
  final bool barrierDismissible; // 是否允许点击外部关闭
  final Widget? content; // 自定义内容
  final TextStyle? titleStyle; // 标题样式
  final TextStyle? messageStyle; // 消息样式

  const AppDialog({ // 构造函数
    super.key,
    this.title,
    this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.showCancel = true,
    this.barrierDismissible = true,
    this.content,
    this.titleStyle,
    this.messageStyle,
  });

  @override
  Widget build(BuildContext context) => AlertDialog( // 构建方法
        title: title == null
            ? null
            : Text(
                title!,
                style: titleStyle ?? Theme.of(context).textTheme.titleLarge,
              ),
        content: content ??
            (message == null
                ? null
                : Text(
                    message!,
                    style: messageStyle ?? Theme.of(context).textTheme.bodyMedium,
                  )),
        actions: [
          if (showCancel)
            AppButton(
              onPressed: () {
                Navigator.of(context).pop();
                onCancel?.call();
              },
              child: Text(cancelText ?? '取消'),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                foregroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                side: MaterialStateProperty.all(BorderSide(color: Theme.of(context).primaryColor)),
              ),
            ),
          AppButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            child: Text(confirmText ?? '确认'),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )),
            ),
          ),
        ],
      );

  static Future<bool?> show( // 显示对话框
    BuildContext context, {
    String? title,
    String? message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool showCancel = true,
    bool barrierDismissible = true,
    Widget? content,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
  }) =>
      showDialog<bool>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) => AppDialog(
          title: title,
          message: message,
          confirmText: confirmText,
          cancelText: cancelText,
          onConfirm: onConfirm,
          onCancel: onCancel,
          showCancel: showCancel,
          barrierDismissible: barrierDismissible,
          content: content,
          titleStyle: titleStyle,
          messageStyle: messageStyle,
        ),
      );
} 