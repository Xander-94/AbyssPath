import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:abysspath01/core/services/deepseek_service.dart';
import 'package:abysspath01/features/learning_path/data/services/path_generation_service.dart';
import 'package:abysspath01/features/learning_path/presentation/pages/generate_path_page.dart';
import 'generate_path_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DeepseekService>()])
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // 加载环境变量
  await dotenv.load(fileName: ".env");

  late MockDeepseekService mockDeepseekService;
  late PathGenerationService pathService;

  setUp(() {
    mockDeepseekService = MockDeepseekService();
    pathService = PathGenerationService(
      deepseekService: mockDeepseekService,
    );
  });

  testWidgets('生成路径页面测试', (WidgetTester tester) async {
    // 构建页面
    await tester.pumpWidget(
      MaterialApp(
        home: GeneratePathPage(),
      ),
    );

    // 验证页面标题
    expect(find.text('生成学习路径'), findsOneWidget);

    // 验证输入字段
    expect(find.text('学习目标'), findsOneWidget);
    expect(find.text('当前水平'), findsOneWidget);
    expect(find.text('目标水平'), findsOneWidget);

    // 验证生成按钮
    expect(find.text('生成路径'), findsOneWidget);

    // 测试表单验证
    await tester.tap(find.text('生成路径'));
    await tester.pumpAndSettle();

    // 验证错误提示
    expect(find.text('请输入学习目标'), findsOneWidget);
    expect(find.text('请输入当前水平'), findsOneWidget);
    expect(find.text('请输入目标水平'), findsOneWidget);

    // 填写表单
    await tester.enterText(find.byType(TextFormField).first, '测试目标');
    await tester.enterText(find.byType(TextFormField).at(1), '当前水平');
    await tester.enterText(find.byType(TextFormField).last, '目标水平');

    // 模拟API响应
    when(mockDeepseekService.generateResponse(any)).thenAnswer((_) async => '''
    {
      "title": "测试路径",
      "description": "测试描述",
      "targetSkills": ["技能1", "技能2"],
      "estimatedDuration": 30,
      "difficulty": "beginner",
      "stages": [
        {
          "title": "阶段1",
          "description": "阶段描述",
          "order": 1,
          "duration": 10,
          "prerequisites": "前置要求",
          "tasks": [
            {
              "title": "任务1",
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
    ''');

    // 点击生成按钮
    await tester.tap(find.text('生成路径'));
    await tester.pumpAndSettle();

    // 验证加载状态
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 等待API响应
    await tester.pump(const Duration(seconds: 1));

    // 验证生成结果
    expect(find.text('生成的路径：'), findsOneWidget);
    expect(find.text('测试路径'), findsOneWidget);
    expect(find.text('测试描述'), findsOneWidget);
    expect(find.text('目标技能：技能1, 技能2'), findsOneWidget);
    expect(find.text('预计时长：30天'), findsOneWidget);
    expect(find.text('难度等级：beginner'), findsOneWidget);
  });
} 