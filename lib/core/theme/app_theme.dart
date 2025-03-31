import 'package:flutter/material.dart'; // 导入Flutter基础库

class AppTheme { // 应用主题类
  static final lightTheme = ThemeData( // 浅色主题
    useMaterial3: true, // 使用Material 3
    colorScheme: ColorScheme.fromSeed( // 从种子颜色生成配色方案
      seedColor: Colors.blue, // 种子颜色
      brightness: Brightness.light, // 亮度
    ),
    appBarTheme: const AppBarTheme(centerTitle: true), // 应用栏主题
    cardTheme: CardTheme(elevation: 2), // 卡片主题
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()), // 输入框主题
  );

  static final darkTheme = ThemeData( // 深色主题
    useMaterial3: true, // 使用Material 3
    colorScheme: ColorScheme.fromSeed( // 从种子颜色生成配色方案
      seedColor: Colors.blue, // 种子颜色
      brightness: Brightness.dark, // 亮度
    ),
    appBarTheme: const AppBarTheme(centerTitle: true), // 应用栏主题
    cardTheme: CardTheme(elevation: 2), // 卡片主题
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()), // 输入框主题
  );
} 