import 'package:flutter_test/flutter_test.dart';
import 'package:abysspath01/features/learning_path/data/models/learning_path.dart';
import 'package:abysspath01/features/learning_path/data/models/path_stage.dart';
import 'package:abysspath01/features/learning_path/data/models/learning_task.dart';

void main() {
  group('LearningPath Model', () {
    final now = DateTime.now();
    final testPath = LearningPath(
      id: 'test-id',
      userId: 'test-user-id',
      title: '测试路径',
      description: '测试描述',
      targetSkills: ['技能1', '技能2'],
      estimatedDuration: '90',
      difficulty: 'intermediate',
      status: 'active',
      createdAt: now,
      updatedAt: now,
    );

    test('应正确创建 LearningPath 实例', () {
      expect(testPath.id, equals('test-id'));
      expect(testPath.userId, equals('test-user-id'));
      expect(testPath.title, equals('测试路径'));
      expect(testPath.targetSkills, equals(['技能1', '技能2']));
      expect(testPath.difficulty, equals('intermediate'));
    });

    test('应正确转换为 JSON', () {
      final json = testPath.toJson();
      expect(json['id'], equals('test-id'));
      expect(json['user_id'], equals('test-user-id'));
      expect(json['target_skills'], equals(['技能1', '技能2']));
    });

    test('应正确从 JSON 创建实例', () {
      final json = {
        'id': 'test-id',
        'user_id': 'test-user-id',
        'title': '测试路径',
        'description': '测试描述',
        'target_skills': ['技能1', '技能2'],
        'estimated_duration': '90',
        'difficulty': 'intermediate',
        'status': 'active',
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      final path = LearningPath.fromJson(json);
      expect(path.id, equals('test-id'));
      expect(path.targetSkills, equals(['技能1', '技能2']));
    });
  });

  group('PathStage Model', () {
    final now = DateTime.now();
    final testStage = PathStage(
      id: 'test-stage-id',
      pathId: 'test-path-id',
      title: '测试阶段',
      description: '阶段描述',
      order: 1,
      duration: 30,
      prerequisites: '基础知识',
      status: 'pending',
      createdAt: now,
      updatedAt: now,
    );

    test('应正确创建 PathStage 实例', () {
      expect(testStage.id, equals('test-stage-id'));
      expect(testStage.pathId, equals('test-path-id'));
      expect(testStage.title, equals('测试阶段'));
      expect(testStage.duration, equals(30));
      expect(testStage.prerequisites, equals('基础知识'));
    });

    test('应正确转换为 JSON', () {
      final json = testStage.toJson();
      expect(json['id'], equals('test-stage-id'));
      expect(json['path_id'], equals('test-path-id'));
      expect(json['duration'], equals(30));
      expect(json['prerequisites'], equals('基础知识'));
    });

    test('应正确从 JSON 创建实例', () {
      final json = {
        'id': 'test-stage-id',
        'path_id': 'test-path-id',
        'title': '测试阶段',
        'description': '阶段描述',
        'order': 1,
        'duration': 30,
        'prerequisites': '基础知识',
        'status': 'pending',
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      final stage = PathStage.fromJson(json);
      expect(stage.id, equals('test-stage-id'));
      expect(stage.duration, equals(30));
      expect(stage.prerequisites, equals('基础知识'));
    });
  });

  group('LearningTask Model', () {
    final now = DateTime.now();
    final deadline = DateTime(2024, 12, 31);
    final testTask = LearningTask(
      id: 'test-task-id',
      stageId: 'test-stage-id',
      title: '测试任务',
      description: '任务描述',
      order: 1,
      type: 'learning',
      status: 'pending',
      deadline: deadline,
      progress: 0.0,
      createdAt: now,
      updatedAt: now,
    );

    test('应正确创建 LearningTask 实例', () {
      expect(testTask.id, equals('test-task-id'));
      expect(testTask.stageId, equals('test-stage-id'));
      expect(testTask.title, equals('测试任务'));
      expect(testTask.type, equals('learning'));
      expect(testTask.deadline, equals(deadline));
      expect(testTask.progress, equals(0.0));
    });

    test('应正确转换为 JSON', () {
      final json = testTask.toJson();
      expect(json['id'], equals('test-task-id'));
      expect(json['stage_id'], equals('test-stage-id'));
      expect(json['type'], equals('learning'));
      expect(json['deadline'], equals(deadline.toIso8601String()));
      expect(json['progress'], equals(0.0));
    });

    test('应正确从 JSON 创建实例', () {
      final json = {
        'id': 'test-task-id',
        'stage_id': 'test-stage-id',
        'title': '测试任务',
        'description': '任务描述',
        'order': 1,
        'type': 'learning',
        'status': 'pending',
        'deadline': deadline.toIso8601String(),
        'progress': 0.0,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      final task = LearningTask.fromJson(json);
      expect(task.id, equals('test-task-id'));
      expect(task.type, equals('learning'));
      expect(task.deadline?.toIso8601String(), equals(deadline.toIso8601String()));
      expect(task.progress, equals(0.0));
    });

    test('progress 应在 0-100 范围内', () {
      expect(
        () => LearningTask(
          id: 'test-id',
          stageId: 'test-stage-id',
          title: '测试任务',
          description: '描述',
          order: 1,
          type: 'learning',
          status: 'pending',
          progress: 101.0, // 超出范围
          createdAt: now,
          updatedAt: now,
        ),
        throwsAssertionError,
      );

      expect(
        () => LearningTask(
          id: 'test-id',
          stageId: 'test-stage-id',
          title: '测试任务',
          description: '描述',
          order: 1,
          type: 'learning',
          status: 'pending',
          progress: -1.0, // 超出范围
          createdAt: now,
          updatedAt: now,
        ),
        throwsAssertionError,
      );
    });
  });
} 