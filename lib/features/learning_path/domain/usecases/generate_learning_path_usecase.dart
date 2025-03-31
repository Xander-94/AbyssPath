import '../services/learning_path_generator.dart';
import '../entities/learning_path.dart';
import '../entities/path_stage.dart';
import '../entities/learning_task.dart';

class GenerateLearningPathUseCase {
  final LearningPathGenerator _generator;

  GenerateLearningPathUseCase(this._generator);

  Future<Map<String, dynamic>> call({
    required Map<String, dynamic> userProfile,
    required String targetDescription,
  }) async {
    try {
      final generatedPath = await _generator.generatePath(
        userProfile: userProfile,
        targetDescription: targetDescription,
      );

      // 将生成的学习路径转换为实体对象
      final learningPath = LearningPath(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userProfile['userId'] ?? '',
        title: targetDescription,
        description: generatedPath['overview'],
        targetSkills: _extractSkills(generatedPath['keyPoints']),
        estimatedDuration: _calculateDuration(generatedPath['stages']),
        difficulty: _determineDifficulty(userProfile),
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final stages = _createStages(generatedPath['stages'], learningPath.id);
      final tasks = _createTasks(stages, generatedPath['stages']);

      return {
        'path': learningPath,
        'stages': stages,
        'tasks': tasks,
        'resources': generatedPath['resources'],
      };
    } catch (e) {
      throw Exception('生成学习路径失败: $e');
    }
  }

  List<String> _extractSkills(String keyPoints) {
    final pattern = RegExp(r'[-*]\s+([^\n]+)');
    return pattern.allMatches(keyPoints)
        .map((m) => m.group(1)?.trim() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }

  int _calculateDuration(List<Map<String, dynamic>> stages) {
    int totalDays = 0;
    for (final stage in stages) {
      final duration = stage['duration'] as String;
      if (duration.contains('天')) {
        totalDays += int.parse(duration.replaceAll(RegExp(r'[^\d]'), ''));
      } else if (duration.contains('周')) {
        totalDays += int.parse(duration.replaceAll(RegExp(r'[^\d]'), '')) * 7;
      } else if (duration.contains('月')) {
        totalDays += int.parse(duration.replaceAll(RegExp(r'[^\d]'), '')) * 30;
      }
    }
    return totalDays;
  }

  String _determineDifficulty(Map<String, dynamic> userProfile) {
    final experience = userProfile['workExperience'] as String?;
    if (experience == null || experience.isEmpty) return 'beginner';
    if (experience.contains('年')) {
      final years = int.tryParse(experience.replaceAll(RegExp(r'[^\d]'), ''));
      if (years != null) {
        if (years < 1) return 'beginner';
        if (years < 3) return 'intermediate';
        return 'advanced';
      }
    }
    return 'beginner';
  }

  List<PathStage> _createStages(List<Map<String, dynamic>> stages, String pathId) {
    return stages.asMap().entries.map((entry) {
      final index = entry.key;
      final stage = entry.value;
      return PathStage(
        id: '${pathId}_stage_$index',
        pathId: pathId,
        name: stage['title'],
        description: stage['content'],
        duration: _parseDuration(stage['duration']),
        prerequisites: _extractPrerequisites(stage['content']),
        order: index,
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }).toList();
  }

  List<LearningTask> _createTasks(List<PathStage> stages, List<Map<String, dynamic>> stageData) {
    final tasks = <LearningTask>[];
    for (var i = 0; i < stages.length; i++) {
      final stage = stages[i];
      final tasksData = stageData[i]['tasks'] as List<String>;
      for (var j = 0; j < tasksData.length; j++) {
        tasks.add(LearningTask(
          id: '${stage.id}_task_$j',
          stageId: stage.id,
          name: tasksData[j],
          description: '',
          type: 'learning',
          deadline: DateTime.now().add(Duration(days: stage.duration)),
          progress: 0.0,
          order: j,
          status: 'pending',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
      }
    }
    return tasks;
  }

  int _parseDuration(String duration) {
    if (duration.contains('天')) {
      return int.parse(duration.replaceAll(RegExp(r'[^\d]'), ''));
    } else if (duration.contains('周')) {
      return int.parse(duration.replaceAll(RegExp(r'[^\d]'), '')) * 7;
    } else if (duration.contains('月')) {
      return int.parse(duration.replaceAll(RegExp(r'[^\d]'), '')) * 30;
    }
    return 7; // 默认一周
  }

  List<String> _extractPrerequisites(String content) {
    final pattern = RegExp(r'前置要求[：:]\s*([^\n]+)');
    final match = pattern.firstMatch(content);
    if (match == null) return [];
    return match.group(1)?.split(RegExp(r'[,，、]')) ?? [];
  }
} 