class SupabaseConstants { // Supabase常量配置
  static const String projectUrl = 'https://eoqnuxeyrxhbuzlxrxsd.supabase.co'; // 项目URL
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVvcW51eGV5cnhoYnV6bHhyeHNkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIxOTE3MDEsImV4cCI6MjA1Nzc2NzcwMX0.h40nv6b6tw7NshwozdEfyBjSAwEbs9wsm-WGX_yFS8w'; // 匿名密钥
  static const String authRedirectUrl = 'io.supabase.abysspath://login-callback'; // 认证重定向URL
  static const Duration sessionTimeout = Duration(days: 30); // 会话超时时间
  static const int maxRetries = 3; // 最大重试次数
  static const Duration retryDelay = Duration(seconds: 1); // 重试延迟
} 