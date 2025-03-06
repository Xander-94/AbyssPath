import 'package:flutter/material.dart';
import 'package:AbssyPath/screens/auth/register_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoggedIn = false; // 登录状态
  String nickname = "游客";
  String userId = "";
  String avatarUrl = "";

  // 模拟用户数据
  final mockUser = {
    "nickname": "Flutter学员",
    "userId": "202308001",
    "avatarUrl": "https://example.com/avatar.jpg"
  };

  void _handleLogin() async {
    // 模拟登录操作
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('登录'),
        content: const Text('确定要登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确认'),
          ),
        ],
      ),
    );

    if (result == true) {
      setState(() {
        isLoggedIn = true;
        nickname = mockUser["nickname"]!;
        userId = mockUser["userId"]!;
        avatarUrl = mockUser["avatarUrl"]!;
      });
    }
  }

  void _handleLogout() {
    setState(() {
      isLoggedIn = false;
      nickname = "游客";
      userId = "";
      avatarUrl = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserInfoSection(),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: isLoggedIn && avatarUrl.isNotEmpty
                ? NetworkImage(avatarUrl)
                : const AssetImage('assets/default_avatar.png') as ImageProvider,
          ),
          const SizedBox(height: 16),
          Text(
            nickname,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isLoggedIn ? "ID: $userId" : "未登录",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          if (!isLoggedIn) ...[
            ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('立即登录'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                             );// 跳转到注册页面
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('注册账号'),
            ),
          ],
          if (isLoggedIn) ...[
            _buildActionItem(Icons.edit, "编辑资料"),
            _buildActionItem(Icons.settings, "账号设置"),
            _buildActionItem(Icons.help_center, "帮助中心"),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleLogout,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red,
              ),
              child: const Text('退出登录'),
            ),
          ],
          if (!isLoggedIn)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                '请登录以查看完整功能',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}