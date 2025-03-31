import '../models/learning_path.dart';
import '../models/path_stage.dart';
import '../models/learning_task.dart';
import '../datasources/learning_path_remote_datasource.dart';

class LearningPathRepository {
  final LearningPathRemoteDataSource _remoteDataSource;

  LearningPathRepository(this._remoteDataSource);

  Future<List<LearningPath>> getPaths(String userId) async {
    return await _remoteDataSource.getPaths(userId);
  }

  Future<LearningPath> getPath(String pathId) async {
    return await _remoteDataSource.getPath(pathId);
  }

  Future<List<PathStage>> getStages(String pathId) async {
    return await _remoteDataSource.getStages(pathId);
  }

  Future<List<LearningTask>> getTasks(String pathId) async {
    return await _remoteDataSource.getTasks(pathId);
  }

  Future<Map<String, double>> getProgress(String pathId) async {
    return await _remoteDataSource.getProgress(pathId);
  }

  Future<void> createPath(LearningPath path) async {
    await _remoteDataSource.createPath(path);
  }

  Future<void> updatePath(LearningPath path) async {
    await _remoteDataSource.updatePath(path);
  }

  Future<PathStage> createStage(PathStage stage) async {
    return await _remoteDataSource.createStage(stage);
  }

  Future<LearningTask> createTask(LearningTask task) async {
    return await _remoteDataSource.createTask(task);
  }
} 