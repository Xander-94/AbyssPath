import 'package:dio/dio.dart'; // 导入dio
import '../../../../core/config/env_config.dart'; // 导入环境变量配置
import '../../domain/entities/assessment.dart'; // 导入评估实体
import '../constants/assessment_questions.dart'; // 导入评估问题
import 'dart:convert'; // 导入dart:convert

class DeepSeekService { // DeepSeek服务
  final Dio _dio; // dio实例

  DeepSeekService() : _dio = Dio() { // 构造函数
    _dio.options.headers['Authorization'] = 'Bearer ${EnvConfig.deepseekApiKey}'; // 设置认证头
  }

  Future<Map<String, dynamic>> analyzeResponse({ // 分析回答
    required String question,
    required String response,
    required String context,
  }) async {
    try {
      final prompt = ''' // 构建提示
$analysisPrompt

问题：$question
回答：$response
上下文：$context

请返回JSON格式的分析结果，包含能力分数、技能种类、技能熟练程度和兴趣爱好：
{
  "scores": {
    "专业技能水平": 0.8,
    "问题解决能力": 0.7,
    "技术更新能力": 0.6,
    "实践应用能力": 0.9,
    "学习能力": 0.8,
    "思维能力": 0.7,
    "自我管理能力": 0.6,
    "适应能力": 0.9,
    "沟通能力": 0.8,
    "领导力": 0.7,
    "团队协作能力": 0.6,
    "人际关系能力": 0.9
  },
  "skillTypes": ["编程语言", "数据库", "Web开发", "移动开发"],
  "skillProficiency": {
    "编程语言": 0.85,
    "数据库": 0.75,
    "Web开发": 0.9,
    "移动开发": 0.8
  },
  "interests": ["人工智能", "云计算", "区块链", "物联网"]
}
''';

      final result = await _dio.post( // 发送请求
        '${EnvConfig.deepseekBaseUrl}/chat/completions',
        data: {
          'model': 'deepseek-chat',
          'messages': [
            {'role': 'system', 'content': prompt},
          ],
          'temperature': 0.7,
          'max_tokens': 1000,
        },
      );

      print('API Response: ${result.data}'); // 打印响应

      final content = result.data['choices'][0]['message']['content'] as String;
      print('Parsing content: $content'); // 打印内容

      // 移除Markdown代码块标记
      final cleanContent = content
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      try {
        final Map<String, dynamic> analysis = Map<String, dynamic>.from(
          const JsonDecoder().convert(cleanContent),
        );
        
        return {
          'scores': Map<String, double>.from(
            (analysis['scores'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, value.toDouble()),
            ),
          ),
          'skillTypes': List<String>.from(analysis['skillTypes']),
          'skillProficiency': Map<String, double>.from(
            (analysis['skillProficiency'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, value.toDouble()),
            ),
          ),
          'interests': List<String>.from(analysis['interests']),
        };
      } catch (e) {
        print('JSON解析错误: $e'); // 打印错误
        // 尝试提取JSON部分
        final jsonStart = cleanContent.indexOf('{');
        final jsonEnd = cleanContent.lastIndexOf('}') + 1;
        if (jsonStart >= 0 && jsonEnd > jsonStart) {
          final jsonStr = cleanContent.substring(jsonStart, jsonEnd);
          final Map<String, dynamic> analysis = Map<String, dynamic>.from(
            const JsonDecoder().convert(jsonStr),
          );
          
          return {
            'scores': Map<String, double>.from(
              (analysis['scores'] as Map<String, dynamic>).map(
                (key, value) => MapEntry(key, value.toDouble()),
              ),
            ),
            'skillTypes': List<String>.from(analysis['skillTypes']),
            'skillProficiency': Map<String, double>.from(
              (analysis['skillProficiency'] as Map<String, dynamic>).map(
                (key, value) => MapEntry(key, value.toDouble()),
              ),
            ),
            'interests': List<String>.from(analysis['interests']),
          };
        }
        throw Exception('无法解析响应格式'); // 抛出异常
      }
    } catch (e) {
      print('API Error: $e'); // 打印错误
      throw Exception('分析失败：$e'); // 抛出异常
    }
  }
} 