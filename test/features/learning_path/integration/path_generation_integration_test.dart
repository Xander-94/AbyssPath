import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:abysspath01/features/learning_path/presentation/pages/generate_path_page.dart';
import 'package:abysspath01/features/learning_path/data/services/path_generation_service.dart';
import 'package:abysspath01/core/services/deepseek_service.dart';
import 'package:abysspath01/core/providers/user_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // 加载环境变量
  await dotenv.load(fileName: ".env");

  late DeepseekService deepseekService;
  late PathGenerationService pathService;

  setUp(() {
    deepseekService = DeepseekService(
      apiKey: dotenv.env['DEEPSEEK_API_KEY'] ?? '',
      baseUrl: dotenv.env['DEEPSEEK_BASE_URL'] ?? '',
    );
    pathService = PathGenerationService(
      deepseekService: deepseekService,
    );
  });

  test('生成学习路径集成测试', () async {
    const userId = 'test_user_id';
    const goal = '3个月内成为初级数据分析师';
    const currentLevel = '做过一个皮制工作牌';
    const targetLevel = '一年内会制作皮包等物品并且抖音粉丝数在500以上';

    final result = await pathService.generatePath(
      userId: userId,
      goal: goal,
      currentLevel: currentLevel,
      targetLevel: targetLevel,
    );

    // 验证基本字段
    expect(result, isA<Map<String, dynamic>>());
    expect(result['title'], isNotNull);
    expect(result['description'], isNotNull);
    expect(result['targetSkills'], isA<List>());
    expect(result['estimatedDuration'], isA<int>());
    expect(result['difficulty'], isIn(['beginner', 'intermediate', 'advanced']));

    // 验证学习阶段
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
} 