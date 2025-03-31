import 'package:flutter_dotenv/flutter_dotenv.dart'; // 导入环境变量包

class EnvConfig { // 环境配置
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? ''; // Supabase URL
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? ''; // Supabase匿名密钥
  static String get deepseekApiKey => dotenv.env['DEEPSEEK_API_KEY'] ?? ''; // DeepSeek API密钥
  static String get deepseekBaseUrl => dotenv.env['DEEPSEEK_BASE_URL'] ?? ''; // 获取DeepSeek基础URL
}