import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/supabase_service.dart';
import '../bloc/learning_path_notifier.dart';
import '../bloc/learning_path_provider.dart';
import '../bloc/learning_path_state.dart';
import '../../data/models/learning_path.dart';
import '../../data/models/path_stage.dart';
import '../../data/models/learning_task.dart';

class PathDetailPage extends ConsumerStatefulWidget {
  final String pathId;

  const PathDetailPage({
    super.key,
    required this.pathId,
  });

  @override
  ConsumerState<PathDetailPage> createState() => _PathDetailPageState();
}

class _PathDetailPageState extends ConsumerState<PathDetailPage> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = SupabaseService.auth.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.id;
      });
      ref.read(learningPathNotifierProvider.notifier).getPathDetail(widget.pathId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_userId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final state = ref.watch(learningPathNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('学习路径详情'),
      ),
      body: state.when(
        initial: () => const Center(child: CircularProgressIndicator()),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (message) => Center(child: Text('错误: $message')),
        loaded: (paths) {
          final path = paths.firstWhere((p) => p.id == widget.pathId);
          return _buildPathDetail(context, path);
        },
        pathDetail: (path, stages, tasks, progress) {
          return _buildPathDetail(context, path, stages: stages, tasks: tasks, progress: progress);
        },
      ),
    );
  }

  Widget _buildPathDetail(
    BuildContext context,
    LearningPath path, {
    List<PathStage>? stages,
    List<LearningTask>? tasks,
    Map<String, double>? progress,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPathHeader(path),
          const SizedBox(height: 24),
          _buildPathDescription(path),
          const SizedBox(height: 24),
          _buildTargetSkills(path),
          const SizedBox(height: 24),
          if (stages != null) _buildStagesList(stages, tasks ?? []),
          if (progress != null) _buildProgressSection(progress),
        ],
      ),
    );
  }

  Widget _buildPathHeader(LearningPath path) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              path.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildStatusChip(path.status),
                const SizedBox(width: 8),
                _buildDifficultyChip(path.difficulty),
                const SizedBox(width: 8),
                Text(
                  '预计 ${path.estimatedDuration} 天',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPathDescription(LearningPath path) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '路径概述',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(path.description),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetSkills(LearningPath path) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '目标技能',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: path.targetSkills.map((skill) {
                return Chip(label: Text(skill));
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStagesList(List<PathStage> stages, List<LearningTask> tasks) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '学习阶段',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stages.length,
              itemBuilder: (context, index) {
                final stage = stages[index];
                final stageTasks = tasks.where((task) => task.stageId == stage.id).toList();
                return _buildStageItem(stage, stageTasks);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageItem(PathStage stage, List<LearningTask> tasks) {
    return ExpansionTile(
      title: Text(stage.title),
      subtitle: Text('${tasks.length} 个任务'),
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return _buildTaskItem(task);
          },
        ),
      ],
    );
  }

  Widget _buildTaskItem(LearningTask task) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text(task.description),
      trailing: CircularProgressIndicator(value: 0.0), // 默认进度为0
    );
  }

  Widget _buildProgressSection(Map<String, double> progress) {
    final totalProgress = progress.values.fold(0.0, (sum, value) => sum + value) / progress.length;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '学习进度',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: totalProgress,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 8),
            Text(
              '已完成 ${(totalProgress * 100).toStringAsFixed(1)}%',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'active':
        color = Colors.green;
        break;
      case 'completed':
        color = Colors.blue;
        break;
      case 'generating':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        status == 'active' ? '进行中' :
        status == 'completed' ? '已完成' :
        status == 'generating' ? '生成中' : '未知',
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }

  Widget _buildDifficultyChip(String difficulty) {
    Color color;
    switch (difficulty) {
      case 'beginner':
        color = Colors.green;
        break;
      case 'intermediate':
        color = Colors.orange;
        break;
      case 'advanced':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        difficulty == 'beginner' ? '入门' :
        difficulty == 'intermediate' ? '中级' :
        difficulty == 'advanced' ? '高级' : '未知',
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }
} 