class AppConstants { // 应用常量配置
  static const String appName = 'AbyssPath'; // 应用名称
  static const String supabaseUrl = 'YOUR_SUPABASE_PROJECT_URL'; // Supabase项目URL
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY'; // Supabase匿名密钥
  static const String deepseekApiKey = 'YOUR_DEEPSEEK_API_KEY'; // DeepSeek API密钥
  static const String deepseekOrgId = 'YOUR_DEEPSEEK_ORG_ID'; // DeepSeek组织ID
  static const Duration apiTimeout = Duration(seconds: 30); // API超时时间
  static const int maxRetries = 3; // 最大重试次数
  static const Duration retryDelay = Duration(seconds: 1); // 重试延迟
} 