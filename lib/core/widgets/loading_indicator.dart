import 'package:flutter/material.dart'; // 导入Flutter Material包

class LoadingIndicator extends StatelessWidget { // 加载指示器组件
  final String? message; // 加载消息
  final Color? color; // 颜色

  const LoadingIndicator({super.key, this.message, this.color}); // 构造函数

  @override
  Widget build(BuildContext context) { // 构建方法
    return Center( // 居中显示
      child: Column( // 垂直布局
        mainAxisAlignment: MainAxisAlignment.center, // 主轴居中
        children: [ // 子组件列表
          CircularProgressIndicator(color: color), // 圆形进度指示器
          if (message != null) ...[ // 如果有消息
            const SizedBox(height: 16), // 间距
            Text(message!, style: TextStyle(color: color)), // 消息文本
          ],
        ],
      ),
    );
  }
} 