import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/services/deepseek_service.dart';
import '../../data/services/path_generation_service.dart';

class GeneratePathPage extends StatefulWidget {
  const GeneratePathPage({super.key});

  @override
  State<GeneratePathPage> createState() => _GeneratePathPageState();
}

class _GeneratePathPageState extends State<GeneratePathPage> {
  final _formKey = GlobalKey<FormState>();
  final _goalController = TextEditingController();
  final _currentLevelController = TextEditingController();
  final _targetLevelController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _generatedPath;

  late final PathGenerationService _pathService;

  @override
  void initState() {
    super.initState();
    _pathService = PathGenerationService(
      deepseekService: DeepseekService(
        apiKey: dotenv.env['DEEPSEEK_API_KEY'] ?? '',
        baseUrl: dotenv.env['DEEPSEEK_BASE_URL'] ?? '',
      ),
    );
  }

  @override
  void dispose() {
    _goalController.dispose();
    _currentLevelController.dispose();
    _targetLevelController.dispose();
    super.dispose();
  }

  Future<void> _generatePath() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await _pathService.generatePath(
        userId: 'test_user_id', // TODO: 使用实际的用户ID
        goal: _goalController.text,
        currentLevel: _currentLevelController.text,
        targetLevel: _targetLevelController.text,
      );

      setState(() {
        _generatedPath = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('生成路径失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('生成学习路径'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _goalController,
                decoration: const InputDecoration(
                  labelText: '学习目标',
                  hintText: '例如：3个月内成为初级数据分析师',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入学习目标';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _currentLevelController,
                decoration: const InputDecoration(
                  labelText: '当前水平',
                  hintText: '例如：做过一个皮制工作牌',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入当前水平';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _targetLevelController,
                decoration: const InputDecoration(
                  labelText: '目标水平',
                  hintText: '例如：一年内会制作皮包等物品并且抖音粉丝数在500以上',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入目标水平';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _generatePath,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('生成路径'),
              ),
              if (_generatedPath != null) ...[
                const SizedBox(height: 24),
                Text(
                  '生成的路径：',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(_generatedPath!['title']),
                Text(_generatedPath!['description']),
                const SizedBox(height: 8),
                Text('目标技能：${_generatedPath!['targetSkills'].join(', ')}'),
                Text('预计时长：${_generatedPath!['estimatedDuration']}天'),
                Text('难度等级：${_generatedPath!['difficulty']}'),
                const SizedBox(height: 16),
                Text(
                  '学习阶段：',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ...(_generatedPath!['stages'] as List).map((stage) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text('阶段：${stage['title']}'),
                    Text('描述：${stage['description']}'),
                    Text('时长：${stage['duration']}天'),
                    Text('前置要求：${stage['prerequisites']}'),
                    const SizedBox(height: 8),
                    Text(
                      '任务：',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    ...(stage['tasks'] as List).map((task) => Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('任务：${task['title']}'),
                          Text('描述：${task['description']}'),
                          Text('类型：${task['type']}'),
                          Text('截止日期：${task['deadline']}'),
                          Text('进度：${task['progress']}%'),
                        ],
                      ),
                    )),
                  ],
                )),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 