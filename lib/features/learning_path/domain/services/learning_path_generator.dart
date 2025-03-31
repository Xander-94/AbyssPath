import 'package:abysspath01/core/services/deepseek_service.dart';
import '../entities/learning_path.dart';
import '../entities/path_stage.dart';
import '../entities/learning_task.dart';

class LearningPathGenerator {
  final DeepseekService _deepseekService;

  LearningPathGenerator(this._deepseekService);

  Future<Map<String, dynamic>> generatePath({
    required Map<String, dynamic> userProfile,
    required String targetDescription,
  }) async {
    final prompt = '''
基于以下用户画像和目标描述，生成一个详细的学习路径规划：

用户画像：
${_formatUserProfile(userProfile)}

目标描述：
$targetDescription

请生成一个包含以下内容的学习路径规划（Markdown格式）：
1. 总体学习路径概述
2. 分阶段学习计划（每个阶段包含具体的学习任务）
3. 每个阶段预计完成时间
4. 关键知识点和技能点
5. 学习资源推荐
''';

    final response = await _deepseekService.generateResponse(prompt);
    return _parseResponse(response);
  }

  String _formatUserProfile(Map<String, dynamic> profile) {
    return '''
- 专业背景：${profile['professionalBackground'] ?? '未提供'}
- 工作经验：${profile['workExperience'] ?? '未提供'}
- 个人特质：${profile['personalTraits'] ?? '未提供'}
- 技能评估：${profile['skillAssessment'] ?? '未提供'}
''';
  }

  Map<String, dynamic> _parseResponse(String response) {
    return {
      'overview': _extractSection(response, '总体学习路径概述'),
      'stages': _extractStages(response),
      'keyPoints': _extractSection(response, '关键知识点和技能点'),
      'resources': _extractSection(response, '学习资源推荐'),
    };
  }

  String _extractSection(String content, String sectionTitle) {
    final pattern = RegExp(r'(?<=# )' + RegExp.escape(sectionTitle) + r'[^\n#]*(?:\n(?!#)[^\n]*)*');
    final match = pattern.firstMatch(content);
    return match?.group(0)?.trim() ?? '';
  }

  List<Map<String, dynamic>> _extractStages(String content) {
    final stages = <Map<String, dynamic>>[];
    final stagePattern = RegExp(r'## 第(\d+)阶段[^#]*(?:\n(?!#)[^\n]*)*');
    final matches = stagePattern.allMatches(content);

    for (final match in matches) {
      final stageContent = match.group(0) ?? '';
      stages.add({
        'title': '第${match.group(1)}阶段',
        'content': stageContent.replaceFirst(RegExp(r'## 第\d+阶段'), '').trim(),
        'duration': _extractDuration(stageContent),
        'tasks': _extractTasks(stageContent),
      });
    }

    return stages;
  }

  String _extractDuration(String content) {
    final pattern = RegExp(r'预计完成时间：([^\n]+)');
    return pattern.firstMatch(content)?.group(1)?.trim() ?? '';
  }

  List<String> _extractTasks(String content) {
    final pattern = RegExp(r'[-*]\s+([^\n]+)');
    return pattern.allMatches(content)
        .map((m) => m.group(1)?.trim() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }
} 