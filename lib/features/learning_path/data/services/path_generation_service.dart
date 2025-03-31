import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/services/deepseek_service.dart';
import '../../domain/entities/learning_path.dart';
import '../../domain/entities/path_stage.dart';
import '../../domain/entities/learning_task.dart';

class PathGenerationService {
  final DeepseekService deepseekService;

  PathGenerationService({
    required this.deepseekService,
  });

  Future<Map<String, dynamic>> generatePath({
    required String userId,
    required String goal,
    required String currentLevel,
    required String targetLevel,
  }) async {
    final prompt = '''
请根据以下用户信息生成一个详细的学习路径规划：

用户画像：
- 用户ID: $userId
- 学习目标: $goal
- 当前水平: $currentLevel
- 目标水平: $targetLevel

返回的JSON格式示例：
{
  "title": "路径标题",
  "description": "路径描述",
  "targetSkills": ["技能1", "技能2"],
  "estimatedDuration": 90,
  "difficulty": "beginner",
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
          "type": "learning",
          "order": 1,
          "deadline": "2024-12-31T00:00:00Z",
          "progress": 0
        }
      ]
    }
  ]
}

请确保：
1. 返回内容必须是合法的JSON格式
2. 所有字符串使用双引号
3. 不要添加任何额外的说明文字
4. difficulty的值只能是：beginner/intermediate/advanced
5. type的值只能是：learning/practice/quiz
6. estimatedDuration和duration必须是整数，表示天数
7. progress必须是0到100之间的数字
8. deadline必须是ISO 8601格式的日期时间字符串
''';

    try {
      final response = await deepseekService.generateResponse(prompt);
      final jsonData = response.trim();
      
      // 尝试解析JSON
      final Map<String, dynamic> result = Map<String, dynamic>.from(
        json.decode(jsonData) as Map,
      );

      // 验证必需字段
      _validatePathData(result);

      return result;
    } catch (e) {
      throw Exception('生成学习路径失败: $e');
    }
  }

  void _validatePathData(Map<String, dynamic> data) {
    // 验证基本字段
    if (!data.containsKey('title') || !data.containsKey('description')) {
      throw FormatException('缺少路径标题或描述');
    }

    // 验证目标技能
    if (!data.containsKey('targetSkills') || 
        !(data['targetSkills'] is List) || 
        (data['targetSkills'] as List).isEmpty) {
      throw FormatException('缺少或无效的目标技能列表');
    }

    // 验证难度等级
    if (!data.containsKey('difficulty') || 
        !['beginner', 'intermediate', 'advanced'].contains(data['difficulty'])) {
      throw FormatException('无效的难度等级');
    }

    // 验证学习阶段
    if (!data.containsKey('stages') || 
        !(data['stages'] is List) || 
        (data['stages'] as List).isEmpty) {
      throw FormatException('缺少或无效的学习阶段');
    }

    // 验证每个阶段
    for (var stage in data['stages']) {
      if (!stage.containsKey('title') || 
          !stage.containsKey('description') || 
          !stage.containsKey('tasks')) {
        throw FormatException('阶段数据不完整');
      }

      // 验证任务
      final tasks = stage['tasks'] as List;
      if (tasks.isEmpty) {
        throw FormatException('阶段任务列表为空');
      }

      for (var task in tasks) {
        if (!task.containsKey('title') || 
            !task.containsKey('description') || 
            !task.containsKey('type') || 
            !task.containsKey('deadline')) {
          throw FormatException('任务数据不完整');
        }

        // 验证任务类型
        if (!['learning', 'practice', 'quiz'].contains(task['type'])) {
          throw FormatException('无效的任务类型');
        }

        // 验证截止日期格式
        try {
          DateTime.parse(task['deadline']);
        } catch (e) {
          throw FormatException('无效的截止日期格式');
        }
      }
    }
  }
} 