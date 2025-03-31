import 'package:flutter/material.dart'; // 导入Flutter基础库
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 导入Riverpod
import 'package:go_router/go_router.dart';
import '../../../../core/services/supabase_service.dart'; // 导入Supabase服务
import '../../../assessment/presentation/pages/deepseek_test_page.dart'; // 导入评估页面
import '../../../learning_path/presentation/pages/path_list_page.dart';

class HomePage extends ConsumerStatefulWidget { // 主页
  const HomePage({super.key}); // 构造函数

  @override
  ConsumerState<HomePage> createState() => _HomePageState(); // 创建状态
}

class _HomePageState extends ConsumerState<HomePage> { // 主页状态
  int _currentIndex = 0; // 当前选中的底部导航栏索引
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = SupabaseService.auth.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.id;
      });
    }
  }

  final List<Widget> _pages = [ // 页面列表
    const Center(child: Text('路径')), // 路径页面
    const DeepseekTestPage(), // 评估页面
    const Center(child: Text('记录')), // 记录页面
    const Center(child: Text('个人')), // 个人页面
  ];

  @override
  Widget build(BuildContext context) {
    if (_userId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          PathListPage(),
          _pages[1],
          _pages[2],
          _pages[3],
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route),
            label: '路径',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: '评估',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: '记录',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async { // 退出登录方法
    try {
      await SupabaseService.auth.signOut(); // 退出登录
      if (mounted) { // 如果组件还在树中
        context.go('/login'); // 导航到登录页
      }
    } catch (e) {
      if (mounted) { // 如果组件还在树中
        ScaffoldMessenger.of(context).showSnackBar( // 显示错误提示
          SnackBar(content: Text('退出失败：$e')),
        );
      }
    }
  }
} 