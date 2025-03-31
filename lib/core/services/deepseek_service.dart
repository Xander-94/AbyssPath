import 'package:dio/dio.dart';

class DeepseekService {
  final String apiKey;
  final String baseUrl;
  final Dio _dio;

  DeepseekService({
    required this.apiKey,
    required this.baseUrl,
  }) : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ));

  Future<String> generateResponse(String prompt) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content': '''你是一个专业的学习路径规划助手。请根据用户提供的信息，生成一个详细的学习路径规划。
返回格式必须是合法的JSON，包含以下字段：
{
  "title": "路径标题",
  "description": "路径描述",
  "targetSkills": ["技能1", "技能2"],
  "estimatedDuration": 90,
  "difficulty": "beginner/intermediate/advanced",
  "stages": [
    {
      "title": "阶段标题",
      "description": "阶段描述",
      "order": 1,
      "duration": 30,
      "prerequisites": "前置要求",
      "tasks": [
        {
          "title": "任务标题",
          "description": "任务描述",
          "type": "learning/practice/quiz",
          "order": 1,
          "deadline": "2024-12-31T00:00:00Z",
          "progress": 0
        }
      ]
    }
  ]
}'''
            },
            {
              'role': 'user',
              'content': prompt
            }
          ],
          'temperature': 0.7,
          'max_tokens': 4000,
          'stream': false,
          'response_format': { 'type': 'json_object' }
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final content = response.data['choices']?[0]?['message']?['content'];
        if (content == null) {
          throw Exception('API 响应格式错误');
        }
        return content;
      } else {
        throw Exception('API调用失败: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('API 端点不存在，请检查 API 地址是否正确');
      } else if (e.response?.statusCode == 401) {
        throw Exception('API 密钥无效或已过期');
      } else if (e.response?.statusCode == 429) {
        throw Exception('API 调用次数超限');
      }
      throw Exception('请求失败: ${e.message}');
    } catch (e) {
      throw Exception('生成响应失败: $e');
    }
  }
} 