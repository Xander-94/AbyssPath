import '../../domain/entities/learning_path.dart';
import '../../domain/entities/path_stage.dart';
import '../../domain/entities/learning_task.dart';
import '../../domain/entities/progress.dart';
import '../../domain/repositories/learning_path_repository.dart';
import '../datasources/learning_path_remote_data_source.dart';

class LearningPathRepositoryImpl implements LearningPathRepository {
  final LearningPathRemoteDataSource _remoteDataSource;

  LearningPathRepositoryImpl(this._remoteDataSource);

  @override
  Future<LearningPath> createLearningPath(LearningPath path) async {
    try {
      return await _remoteDataSource.createLearningPath(path);
    } catch (e) {
      throw Exception('创建学习路径失败：${e.toString()}');
    }
  }

  @override
  Future<List<LearningPath>> getUserLearningPaths(String userId) async {
    try {
      return await _remoteDataSource.getUserLearningPaths(userId);
    } catch (e) {
      throw Exception('获取用户学习路径失败：${e.toString()}');
    }
  }

  @override
  Future<PathStage> createPathStage(PathStage stage) async {
    try {
      return await _remoteDataSource.createPathStage(stage);
    } catch (e) {
      throw Exception('创建学习阶段失败：${e.toString()}');
    }
  }

  @override
  Future<List<PathStage>> getPathStages(String pathId) async {
    try {
      return await _remoteDataSource.getPathStages(pathId);
    } catch (e) {
      throw Exception('获取学习阶段失败：${e.toString()}');
    }
  }

  @override
  Future<LearningTask> createLearningTask(LearningTask task) async {
    try {
      return await _remoteDataSource.createLearningTask(task);
    } catch (e) {
      throw Exception('创建学习任务失败：${e.toString()}');
    }
  }

  @override
  Future<List<LearningTask>> getStageTasks(String stageId) async {
    try {
      return await _remoteDataSource.getStageTasks(stageId);
    } catch (e) {
      throw Exception('获取学习任务失败：${e.toString()}');
    }
  }

  @override
  Future<Progress> createProgress(Progress progress) async {
    try {
      return await _remoteDataSource.createProgress(progress);
    } catch (e) {
      throw Exception('创建学习进度失败：${e.toString()}');
    }
  }

  @override
  Future<List<Progress>> getUserProgress(String userId) async {
    try {
      return await _remoteDataSource.getUserProgress(userId);
    } catch (e) {
      throw Exception('获取用户进度失败：${e.toString()}');
    }
  }
} 