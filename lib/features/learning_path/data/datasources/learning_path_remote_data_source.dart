import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/learning_path.dart';
import '../../domain/entities/path_stage.dart';
import '../../domain/entities/learning_task.dart';
import '../../domain/entities/progress.dart';

class LearningPathRemoteDataSource {
  final SupabaseClient _client;

  LearningPathRemoteDataSource(this._client);

  Future<LearningPath> createLearningPath(LearningPath path) async {
    try {
      final data = {
        'id': path.id,
        'user_id': path.userId,
        'title': path.title,
        'description': path.description,
        'target_skills': path.targetSkills,
        'estimated_duration': path.estimatedDuration,
        'difficulty': path.difficulty,
        'status': path.status,
        'created_at': path.createdAt.toUtc().toIso8601String(),
        'updated_at': path.updatedAt.toUtc().toIso8601String(),
      };

      final response = await _client
          .from('learning_paths')
          .insert(data)
          .select()
          .single();

      if (response == null) {
        throw Exception('创建学习路径失败: 服务器返回空数据');
      }

      final targetSkills = response['target_skills'];
      final List<String> skills = targetSkills == null 
          ? []
          : (targetSkills is List 
              ? targetSkills.map((e) => e.toString()).toList()
              : []);

      final Map<String, dynamic> jsonData = {
        'id': response['id'] ?? '',
        'userId': response['user_id'] ?? '',
        'title': response['title'] ?? '',
        'description': response['description'] ?? '',
        'targetSkills': skills,
        'estimatedDuration': response['estimated_duration'] ?? 0,
        'difficulty': response['difficulty'] ?? 'beginner',
        'status': response['status'] ?? 'pending',
        'createdAt': response['created_at'] != null 
            ? DateTime.parse(response['created_at'].toString()).toLocal()
            : DateTime.now(),
        'updatedAt': response['updated_at'] != null
            ? DateTime.parse(response['updated_at'].toString()).toLocal()
            : DateTime.now(),
      };

      return LearningPath.fromJson(jsonData);
    } catch (e) {
      throw Exception('创建学习路径失败: $e');
    }
  }

  Future<List<LearningPath>> getUserLearningPaths(String userId) async {
    try {
      final response = await _client
          .from('learning_paths')
          .select()
          .eq('user_id', userId)
          .order('created_at');

      if (response == null || !(response is List)) {
        return [];
      }

      return response.map((json) {
        final targetSkills = json['target_skills'];
        final List<String> skills = targetSkills == null 
            ? []
            : (targetSkills is List 
                ? targetSkills.map((e) => e.toString()).toList()
                : []);

        final Map<String, dynamic> data = {
          'id': json['id'] ?? '',
          'userId': json['user_id'] ?? '',
          'title': json['title'] ?? '',
          'description': json['description'] ?? '',
          'targetSkills': skills,
          'estimatedDuration': json['estimated_duration'] ?? 0,
          'difficulty': json['difficulty'] ?? 'beginner',
          'status': json['status'] ?? 'pending',
          'createdAt': json['created_at'] != null 
              ? DateTime.parse(json['created_at'].toString()).toLocal()
              : DateTime.now(),
          'updatedAt': json['updated_at'] != null
              ? DateTime.parse(json['updated_at'].toString()).toLocal()
              : DateTime.now(),
        };
        return LearningPath.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('获取用户学习路径失败: $e');
    }
  }

  Future<PathStage> createPathStage(PathStage stage) async {
    try {
      final data = {
        'id': stage.id,
        'path_id': stage.pathId,
        'name': stage.name,
        'description': stage.description,
        'duration': stage.duration,
        'prerequisites': stage.prerequisites,
        'order': stage.order,
        'status': stage.status,
        'created_at': stage.createdAt.toIso8601String(),
        'updated_at': stage.updatedAt.toIso8601String(),
      };

      final response = await _client
          .from('path_stages')
          .insert(data)
          .select()
          .single();

      if (response == null) {
        throw Exception('创建学习阶段失败: 服务器返回空数据');
      }

      return PathStage.fromJson(Map<String, dynamic>.from(response));
    } catch (e) {
      throw Exception('创建学习阶段失败: $e');
    }
  }

  Future<List<PathStage>> getPathStages(String pathId) async {
    try {
      final response = await _client
          .from('path_stages')
          .select()
          .eq('path_id', pathId)
          .order('order');

      if (response == null) {
        return [];
      }

      return (response as List)
          .map((json) => PathStage.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      throw Exception('获取学习阶段失败: $e');
    }
  }

  Future<LearningTask> createLearningTask(LearningTask task) async {
    try {
      final data = {
        'id': task.id,
        'stage_id': task.stageId,
        'name': task.name,
        'description': task.description,
        'type': task.type,
        'deadline': task.deadline.toIso8601String(),
        'progress': task.progress,
        'order': task.order,
        'status': task.status,
        'created_at': task.createdAt.toIso8601String(),
        'updated_at': task.updatedAt.toIso8601String(),
      };

      final response = await _client
          .from('learning_tasks')
          .insert(data)
          .select()
          .single();

      if (response == null) {
        throw Exception('创建学习任务失败: 服务器返回空数据');
      }

      return LearningTask.fromJson(Map<String, dynamic>.from(response));
    } catch (e) {
      throw Exception('创建学习任务失败: $e');
    }
  }

  Future<List<LearningTask>> getStageTasks(String stageId) async {
    try {
      final response = await _client
          .from('learning_tasks')
          .select()
          .eq('stage_id', stageId)
          .order('order');

      if (response == null) {
        return [];
      }

      return (response as List)
          .map((json) => LearningTask.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      throw Exception('获取学习任务失败: $e');
    }
  }

  Future<Progress> createProgress(Progress progress) async {
    try {
      final data = {
        'id': progress.id,
        'user_id': progress.userId,
        'path_id': progress.pathId,
        'task_id': progress.taskId,
        'status': progress.status,
        'start_time': progress.startTime.toIso8601String(),
        'completion_time': progress.completionTime?.toIso8601String(),
        'notes': progress.notes,
        'feedback': progress.feedback,
      };

      final response = await _client
          .from('progress')
          .insert(data)
          .select()
          .single();

      if (response == null) {
        throw Exception('创建进度记录失败: 服务器返回空数据');
      }

      return Progress.fromJson(Map<String, dynamic>.from(response));
    } catch (e) {
      throw Exception('创建进度记录失败: $e');
    }
  }

  Future<List<Progress>> getUserProgress(String userId) async {
    try {
      final response = await _client
          .from('progress')
          .select()
          .eq('user_id', userId)
          .order('start_time');

      if (response == null) {
        return [];
      }

      return (response as List)
          .map((json) => Progress.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      throw Exception('获取用户进度失败: $e');
    }
  }

  Future<void> updateTaskProgress(String taskId, double progress) async {
    await _client.from('learning_tasks').update({
      'progress': progress,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', taskId);
  }

  Future<void> updateStageStatus(String stageId, String status) async {
    await _client.from('path_stages').update({
      'status': status,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', stageId);
  }

  Future<void> updatePathStatus(String pathId, String status) async {
    await _client.from('learning_paths').update({
      'status': status,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', pathId);
  }
} 