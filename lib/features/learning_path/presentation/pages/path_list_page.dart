import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/supabase_service.dart';
import '../bloc/learning_path_notifier.dart';
import '../bloc/learning_path_provider.dart';
import '../bloc/learning_path_state.dart';
import '../../data/models/learning_path.dart';
import '../../data/models/path_stage.dart';
import '../../data/models/learning_task.dart';
import 'generate_path_page.dart';
import 'path_detail_page.dart';

class PathListPage extends ConsumerStatefulWidget {
  const PathListPage({super.key});

  @override
  ConsumerState<PathListPage> createState() => _PathListPageState();
}

class _PathListPageState extends ConsumerState<PathListPage> {
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
      ref.read(learningPathNotifierProvider.notifier).getPaths(user.id);
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
        title: const Text('我的学习路径'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/paths/generate');
            },
          ),
        ],
      ),
      body: state.when(
        initial: () => const Center(child: CircularProgressIndicator()),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (message) => Center(child: Text('错误: $message')),
        loaded: (paths) => _buildPathList(paths),
        pathDetail: (path, stages, tasks, progress) => _buildPathList([path]),
      ),
    );
  }

  Widget _buildPathList(List<LearningPath> paths) {
    if (paths.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '还没有学习路径',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.push('/paths/generate');
              },
              child: const Text('创建学习路径'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: paths.length,
      itemBuilder: (context, index) {
        final path = paths[index];
        return _buildPathCard(path);
      },
    );
  }

  Widget _buildPathCard(LearningPath path) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          context.push('/paths/${path.id}', extra: path.userId);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      path.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildStatusChip(path.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                path.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
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