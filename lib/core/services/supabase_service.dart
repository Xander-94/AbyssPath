import 'package:supabase_flutter/supabase_flutter.dart'; // 导入Supabase包
import '../constants/supabase_constants.dart'; // 导入常量配置

class SupabaseService { // Supabase服务类
  static final SupabaseClient _client = SupabaseClient( // 创建客户端实例
    SupabaseConstants.projectUrl, // 项目URL
    SupabaseConstants.anonKey, // 匿名密钥
    authOptions: const FlutterAuthClientOptions( // 认证选项
      autoRefreshToken: true, // 自动刷新令牌
    ),
  );

  static SupabaseClient get client => _client; // 获取客户端实例

  static Future<void> initialize() async { // 初始化方法
    await Supabase.initialize( // 初始化Supabase
      url: SupabaseConstants.projectUrl, // 项目URL
      anonKey: SupabaseConstants.anonKey, // 匿名密钥
      authOptions: const FlutterAuthClientOptions( // 认证选项
        autoRefreshToken: true, // 自动刷新令牌
      ),
    );
  }

  static Future<void> dispose() async { // 释放方法
    await Supabase.instance.dispose(); // 释放Supabase实例
  }
} 