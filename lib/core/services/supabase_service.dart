import 'package:supabase_flutter/supabase_flutter.dart'; // 导入Supabase包
import '../config/env_config.dart'; // 导入环境配置

class SupabaseService { // Supabase服务类
  static final SupabaseClient client = Supabase.instance.client;
  static final GoTrueClient auth = Supabase.instance.client.auth;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
    );
  }

  static Future<void> dispose() async { // 释放方法
    await Supabase.instance.dispose(); // 释放Supabase实例
  }
} 