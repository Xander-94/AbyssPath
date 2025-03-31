import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/learning_path.dart';
import '../models/path_stage.dart';
import '../models/learning_task.dart';

class LearningPathRemoteDataSource {
  final SupabaseClient _client;

  LearningPathRemoteDataSource(this._client);

  Future<List<LearningPath>> getPaths(String userId) async {
    final response = await _client
        .from('learning_paths')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (response as List).map((json) => LearningPath.fromJson(json)).toList();
  }

  Future<LearningPath> getPath(String pathId) async {
    final response = await _client
        .from('learning_paths')
        .select()
        .eq('id', pathId)
        .single();
    return LearningPath.fromJson(response);
  }

  Future<List<PathStage>> getStages(String pathId) async {
    final response = await _client
        .from('path_stages')
        .select()
        .eq('path_id', pathId)
        .order('order');
    return (response as List).map((json) => PathStage.fromJson(json)).toList();
  }

  Future<List<LearningTask>> getTasks(String pathId) async {
    final response = await _client
        .from('learning_tasks')
        .select('*, path_stages!inner(*)')
        .eq('path_stages.path_id', pathId)
        .order('order');
    return (response as List).map((json) => LearningTask.fromJson(json)).toList();
  }

  Future<Map<String, double>> getProgress(String pathId) async {
    final response = await _client
        .from('task_progress')
        .select('task_id, progress')
        .eq('path_id', pathId);
    return Map.fromEntries(
      (response as List).map((json) => MapEntry(json['task_id'], json['progress'])),
    );
  }

  Future<void> createPath(LearningPath path) async {
    await _client.from('learning_paths').insert(path.toJson());
  }

  Future<void> updatePath(LearningPath path) async {
    await _client
        .from('learning_paths')
        .update(path.toJson())
        .eq('id', path.id);
  }

  Future<PathStage> createStage(PathStage stage) async {
    final response = await _client
        .from('path_stages')
        .insert(stage.toJson())
        .select()
        .single();
    return PathStage.fromJson(response);
  }

  Future<LearningTask> createTask(LearningTask task) async {
    final response = await _client
        .from('learning_tasks')
        .insert(task.toJson())
        .select()
        .single();
    return LearningTask.fromJson(response);
  }
} 