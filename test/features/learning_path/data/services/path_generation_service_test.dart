import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:abysspath01/core/services/deepseek_service.dart';
import 'package:abysspath01/features/learning_path/data/services/path_generation_service.dart';
import 'path_generation_service_test.mocks.dart';
import 'package:abysspath01/features/learning_path/data/models/learning_path.dart';
import 'package:abysspath01/features/learning_path/data/models/path_stage.dart';
import 'package:abysspath01/features/learning_path/data/models/learning_task.dart';
import 'mock_deepseek_service.dart' as mock;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

@GenerateNiceMocks([MockSpec<DeepseekService>()])
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // 加载环境变量
  await dotenv.load(fileName: ".env");

  late PathGenerationService pathService;
  late MockDeepseekService mockDeepseekService;
  late DeepseekService realDeepseekService;

  setUp(() {
    mockDeepseekService = MockDeepseekService();
    pathService = PathGenerationService(
      deepseekService: mockDeepseekService,
    );
    realDeepseekService = DeepseekService(
      apiKey: dotenv.env['DEEPSEEK_API_KEY'] ?? '',
      baseUrl: dotenv.env['DEEPSEEK_BASE_URL'] ?? '',
    );
  });

  group('generatePath', () {
    const testUserId = 'test-user-id';
    const testGoal = '3个月内成为初级数据分析师';
    const testCurrentLevel = '做过一个皮制工作牌';
    const testTargetLevel = '一年内会制作皮包等物品并且抖音粉丝数在500以上';

    const validResponse = '''
{
  "title": "皮具制作进阶学习路径",
  "description": "从基础到专业的皮具制作学习计划",
  "targetSkills": ["皮具设计", "皮革裁剪", "手工缝制", "工具使用", "社媒营销"],
  "estimatedDuration": 365,
  "difficulty": "intermediate",
  "stages": [
    {
      "title": "基础技能巩固",
      "description": "巩固基本的皮具制作技能",
      "order": 1,
      "duration": 30,
      "prerequisites": "基本的手工能力",
      "tasks": [
        {
          "title": "工具使用进阶",
          "description": "掌握各类皮具制作工具的专业使用方法",
          "type": "learning",
          "order": 1,
          "deadline": "2024-04-30T00:00:00Z",
          "progress": 0
        }
      ]
    }
  ]
}''';

    String expectedPrompt(String userId, String goal, String currentLevel, String targetLevel) => '''
请根据以下用户信息生成一个学习路径规划，返回格式必须是严格的JSON格式：

用户信息：
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

    test('测试实际Deepseek API输出', () async {
      // 使用真实的Deepseek服务
      final realPathService = PathGenerationService(
        deepseekService: realDeepseekService,
      );

      // 生成学习路径
      final result = await realPathService.generatePath(
        userId: testUserId,
        goal: testGoal,
        currentLevel: testCurrentLevel,
        targetLevel: testTargetLevel,
      );

      // 验证结果
      expect(result, isA<Map<String, dynamic>>());
      expect(result['title'], isNotNull);
      expect(result['description'], isNotNull);
      expect(result['targetSkills'], isA<List>());
      expect(result['estimatedDuration'], isA<int>());
      expect(result['difficulty'], isIn(['beginner', 'intermediate', 'advanced']));
      expect(result['stages'], isA<List>());
      expect(result['stages'], isNotEmpty);

      // 验证第一个阶段
      final firstStage = result['stages'][0];
      expect(firstStage['title'], isNotNull);
      expect(firstStage['description'], isNotNull);
      expect(firstStage['order'], isA<int>());
      expect(firstStage['duration'], isA<int>());
      expect(firstStage['tasks'], isA<List>());
      expect(firstStage['tasks'], isNotEmpty);

      // 验证第一个任务
      final firstTask = firstStage['tasks'][0];
      expect(firstTask['title'], isNotNull);
      expect(firstTask['description'], isNotNull);
      expect(firstTask['type'], isIn(['learning', 'practice', 'quiz']));
      expect(firstTask['order'], isA<int>());
      expect(firstTask['progress'], isA<num>());
      expect(firstTask['progress'], inInclusiveRange(0, 100));
      expect(DateTime.tryParse(firstTask['deadline']), isNotNull);
    });

    test('成功生成学习路径时应返回有效的JSON数据', () async {
      // Arrange
      when(mockDeepseekService.generateResponse(any)).thenAnswer((_) async => validResponse);

      // Act
      final result = await pathService.generatePath(
        userId: testUserId,
        goal: testGoal,
        currentLevel: testCurrentLevel,
        targetLevel: testTargetLevel,
      );

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['title'], equals('皮具制作进阶学习路径'));
      expect(result['estimatedDuration'], equals(365));
      expect(result['difficulty'], equals('intermediate'));
      expect(result['stages'], isA<List>());
      expect(result['stages'][0]['tasks'], isA<List>());
    });

    test('当API返回无效JSON时应抛出FormatException', () async {
      // Arrange
      when(mockDeepseekService.generateResponse(any)).thenAnswer((_) async => 'Invalid JSON');

      // Act & Assert
      expect(
        () => pathService.generatePath(
          userId: testUserId,
          goal: testGoal,
          currentLevel: testCurrentLevel,
          targetLevel: testTargetLevel,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('当API调用失败时应抛出异常', () async {
      // Arrange
      when(mockDeepseekService.generateResponse(any)).thenThrow(Exception('API调用失败'));

      // Act & Assert
      expect(
        () => pathService.generatePath(
          userId: testUserId,
          goal: testGoal,
          currentLevel: testCurrentLevel,
          targetLevel: testTargetLevel,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('生成的路径数据应符合模型要求', () async {
      // Arrange
      when(mockDeepseekService.generateResponse(any)).thenAnswer((_) async => validResponse);

      // Act
      final result = await pathService.generatePath(
        userId: testUserId,
        goal: testGoal,
        currentLevel: testCurrentLevel,
        targetLevel: testTargetLevel,
      );

      // Assert
      final stages = result['stages'] as List;
      final firstStage = stages[0] as Map<String, dynamic>;
      final firstTask = firstStage['tasks'][0] as Map<String, dynamic>;

      // 验证必需字段
      expect(firstStage['title'], isNotNull);
      expect(firstStage['description'], isNotNull);
      expect(firstStage['order'], isA<int>());
      expect(firstStage['duration'], isA<int>());

      expect(firstTask['title'], isNotNull);
      expect(firstTask['description'], isNotNull);
      expect(firstTask['type'], isIn(['learning', 'practice', 'quiz']));
      expect(firstTask['order'], isA<int>());
      expect(firstTask['progress'], isA<num>());
      
      // 验证字段值的合法性
      expect(result['difficulty'], isIn(['beginner', 'intermediate', 'advanced']));
      expect(result['estimatedDuration'], isA<int>());
      expect(firstStage['duration'], isA<int>());
      expect(firstTask['progress'], inInclusiveRange(0, 100));
    });
  });

  test('生成学习路径测试', () async {
    final result = await pathService.generatePath(
      goal: '成为Flutter开发者',
      currentLevel: '初学者',
      targetLevel: '中级开发者',
      userId: 'test_user_id',
    );

    expect(result, isA<Map<String, dynamic>>());
    expect(result['title'], equals('Flutter开发学习路径'));
    expect(result['description'], equals('从初学者到中级开发者的Flutter学习计划'));
    expect(result['targetSkills'], equals(['Flutter', 'Dart']));
    expect(result['estimatedDuration'], equals(90));
    expect(result['difficulty'], equals('intermediate'));
    expect(result['stages'], isA<List>());
    expect(result['stages'], isNotEmpty);

    final firstStage = (result['stages'] as List).first;
    expect(firstStage, isA<Map<String, dynamic>>());
    expect(firstStage['title'], equals('Flutter基础'));
    expect(firstStage['description'], equals('学习Flutter基础知识'));
    expect(firstStage['order'], equals(1));
    expect(firstStage['duration'], equals(30));
    expect(firstStage['tasks'], isA<List>());
    expect(firstStage['tasks'], isNotEmpty);

    final firstTask = (firstStage['tasks'] as List).first;
    expect(firstTask, isA<Map<String, dynamic>>());
    expect(firstTask['title'], equals('Dart语言基础'));
    expect(firstTask['description'], equals('学习Dart语言基础语法'));
    expect(firstTask['type'], equals('learning'));
    expect(firstTask['order'], equals(1));
    expect(firstTask['deadline'], equals('2024-12-31T00:00:00Z'));
    expect(firstTask['progress'], equals(0));
  });
} 