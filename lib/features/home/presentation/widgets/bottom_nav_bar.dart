import 'package:flutter/material.dart'; // 导入Flutter基础库

class AppBottomNavBar extends StatelessWidget { // 底部导航栏组件
  final int currentIndex; // 当前选中的索引
  final ValueChanged<int> onTap; // 点击回调

  const AppBottomNavBar({ // 构造函数
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => NavigationBar( // 构建方法
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        destinations: const [ // 导航项
          NavigationDestination( // 路径
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route),
            label: '路径',
          ),
          NavigationDestination( // 评估
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: '评估',
          ),
          NavigationDestination( // 记录
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: '记录',
          ),
          NavigationDestination( // 我的
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      );
} 