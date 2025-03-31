import 'package:flutter_riverpod/flutter_riverpod.dart'; // 导入Riverpod
import '../../domain/entities/assessment.dart'; // 导入评估实体
import '../../data/services/deepseek_service.dart'; // 导入DeepSeek服务
import '../../data/constants/assessment_questions.dart'; // 导入评估问题
import 'assessment_state.dart'; // 导入评估状态

final assessmentNotifierProvider = StateNotifierProvider<AssessmentNotifier, AssessmentState>((ref) { // 创建评估状态提供者
  return AssessmentNotifier(DeepSeekService()); // 返回评估状态管理器
});

class AssessmentNotifier extends StateNotifier<AssessmentState> { // 评估状态管理器
  final DeepSeekService _deepSeekService; // DeepSeek服务
  late Assessment _session; // 评估会话
  int _currentQuestionIndex = 0; // 当前问题索引
  List<String> _skillTypes = []; // 技能种类列表
  Map<String, double> _skillProficiency = {}; // 技能熟练程度
  List<String> _interests = []; // 兴趣爱好列表

  AssessmentNotifier(this._deepSeekService) : super(const AssessmentState.initial()); // 构造函数

  Future<void> startAssessment() async { // 开始评估
    _session = Assessment( // 创建评估会话
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user_id', // TODO: 获取当前用户ID
      startTime: DateTime.now(),
      interactions: [],
    );

    state = AssessmentState.inProgress( // 设置进行中状态
      session: _session,
      currentQuestion: _getNextQuestion(),
      progress: 0.0,
    );
  }

  Future<void> handleResponse(String response) async { // 处理回答
    if (!state.maybeMap( // 检查状态
      inProgress: (_) => true,
      orElse: () => false,
    )) return;

    final currentState = state.maybeMap( // 获取当前状态
      inProgress: (state) => state,
      orElse: () => throw Exception('Invalid state'),
    );

    try {
      // 分析回答
      final analysis = await _deepSeekService.analyzeResponse( // 分析回答
        question: currentState.currentQuestion,
        response: response,
        context: _getSessionContext(),
      );

      // 更新技能种类
      _skillTypes = [..._skillTypes, ...analysis['skillTypes'] as List<String>];
      _skillTypes = _skillTypes.toSet().toList(); // 去重

      // 更新技能熟练程度
      final newProficiency = analysis['skillProficiency'] as Map<String, double>;
      _skillProficiency = Map.fromEntries(
        _skillProficiency.entries.toList()..addAll(newProficiency.entries),
      );

      // 更新兴趣爱好
      _interests = [..._interests, ...analysis['interests'] as List<String>];
      _interests = _interests.toSet().toList(); // 去重

      // 记录互动
      final interaction = Interaction( // 创建互动记录
        question: currentState.currentQuestion,
        userResponse: response,
        timestamp: DateTime.now(),
        traits: analysis['scores'] as Map<String, double>,
      );

      // 更新会话
      _session = _session.copyWith( // 更新会话
        interactions: [..._session.interactions, interaction],
      );

      // 继续下一个问题或结束评估
      if (_currentQuestionIndex < _getTotalQuestions() - 1) { // 如果还有问题
        _currentQuestionIndex++; // 增加问题索引
        state = AssessmentState.inProgress( // 设置进行中状态
          session: _session,
          currentQuestion: _getNextQuestion(),
          progress: _currentQuestionIndex / _getTotalQuestions(),
        );
      } else {
        // 创建用户画像
        final userProfile = UserProfile( // 创建用户画像
          hardSkills: _calculateAverageTraits('hardSkills'), // 计算硬核能力
          metaSkills: _calculateAverageTraits('metaSkills'), // 计算元能力
          influence: _calculateAverageTraits('influence'), // 计算影响力
          summary: _generateSummary(), // 生成总结
          skillTypes: _skillTypes, // 技能种类
          skillProficiency: _skillProficiency, // 技能熟练程度
          interests: _interests, // 兴趣爱好
        );

        state = AssessmentState.completed( // 设置完成状态
          session: _session.copyWith(userProfile: userProfile), // 更新会话
        );
      }
    } catch (e) {
      state = AssessmentState.error(e.toString()); // 设置错误状态
    }
  }

  Map<String, double> _calculateAverageTraits(String category) { // 计算平均特征
    final traits = <String, List<double>>{}; // 特征列表
    for (final interaction in _session.interactions) { // 遍历互动记录
      if (interaction.traits != null) { // 如果有特征
        interaction.traits!.forEach((key, value) => // 遍历特征
          traits.putIfAbsent(key, () => []).add(value), // 添加值
        );
      }
    }
    return traits.map((key, values) => MapEntry(key, values.reduce((a, b) => a + b) / values.length)); // 计算平均值
  }

  String _generateSummary() { // 生成总结
    final skills = _skillTypes.join('、'); // 连接技能种类
    final interests = _interests.join('、'); // 连接兴趣爱好
    final proficiency = _skillProficiency.entries // 获取技能熟练程度
        .map((e) => '${e.key}(${(e.value * 100).toStringAsFixed(0)}%)') // 格式化
        .join('、'); // 连接
    return '根据评估结果，您擅长$skills等领域，其中$proficiency，对$interests等领域感兴趣，具有${_calculateAverageTraits('hardSkills')['专业技能水平']?.toStringAsFixed(2) ?? '0.0'}的专业技能水平。'; // 生成总结
  }

  String _getNextQuestion() { // 获取下一个问题
    final category = _getCurrentCategory(); // 获取当前类别
    final questions = assessmentQuestions[category]!; // 获取问题列表
    return questions[_currentQuestionIndex % questions.length]; // 返回问题
  }

  String _getCurrentCategory() { // 获取当前类别
    final categories = assessmentQuestions.keys.toList(); // 获取类别列表
    return categories[_currentQuestionIndex ~/ 4]; // 返回类别
  }

  int _getTotalQuestions() { // 获取总问题数
    return assessmentQuestions.values // 获取问题列表
        .map((questions) => questions.length) // 获取问题长度
        .reduce((a, b) => a + b); // 求和
  }

  String _getSessionContext() { // 获取会话上下文
    return _session.interactions // 获取互动记录
        .map((i) => 'Q: ${i.question}\nA: ${i.userResponse}') // 格式化
        .join('\n\n'); // 连接
  }
} 