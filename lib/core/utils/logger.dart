import 'package:flutter/foundation.dart'; // 导入Flutter基础包

class Logger { // 日志工具类
  static void debug(String message) { // 调试日志
    if (kDebugMode) print('🔍 DEBUG: $message'); // 仅在调试模式下打印
  }

  static void info(String message) { // 信息日志
    if (kDebugMode) print('ℹ️ INFO: $message'); // 仅在调试模式下打印
  }

  static void warning(String message) { // 警告日志
    if (kDebugMode) print('⚠️ WARNING: $message'); // 仅在调试模式下打印
  }

  static void error(String message, [dynamic error]) { // 错误日志
    if (kDebugMode) print('❌ ERROR: $message${error != null ? '\n$error' : ''}'); // 仅在调试模式下打印
  }
} 