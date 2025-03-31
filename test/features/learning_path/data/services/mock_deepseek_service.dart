import 'package:abysspath01/core/services/deepseek_service.dart';

class MockDeepseekService implements DeepseekService {
  @override
  String get apiKey => 'test_api_key';

  @override
  String get baseUrl => 'https://test.api.deepseek.com';

  @override
  Future<String> generateResponse(String prompt) async {
    return '''
    {
      "title": "Flutter开发学习路径",
      "description": "从初学者到中级开发者的Flutter学习计划",
      "targetSkills": ["Flutter", "Dart"],
      "estimatedDuration": 90,
      "difficulty": "intermediate",
      "stages": [
        {
          "title": "Flutter基础",
          "description": "学习Flutter基础知识",
          "order": 1,
          "duration": 30,
          "tasks": [
            {
              "title": "Dart语言基础",
              "description": "学习Dart语言基础语法",
              "type": "learning",
              "order": 1,
              "deadline": "2024-12-31T00:00:00Z",
              "progress": 0
            }
          ]
        }
      ]
    }
    ''';
  }
} 