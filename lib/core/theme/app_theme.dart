import 'package:flutter/material.dart'; // 导入Flutter Material包

class AppTheme { // 应用主题配置
  static ThemeData get lightTheme => ThemeData( // 浅色主题
    useMaterial3: true, // 使用Material 3
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), // 从蓝色种子生成配色方案
    appBarTheme: const AppBarTheme(centerTitle: true), // 应用栏主题
    cardTheme: CardTheme(elevation: 2), // 卡片主题
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()), // 输入框主题
  );

  static ThemeData get darkTheme => ThemeData( // 深色主题
    useMaterial3: true, // 使用Material 3
    brightness: Brightness.dark, // 深色亮度
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark), // 深色配色方案
    appBarTheme: const AppBarTheme(centerTitle: true), // 应用栏主题
    cardTheme: CardTheme(elevation: 2), // 卡片主题
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()), // 输入框主题
  );
} 