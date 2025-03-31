import '../entities/learning_path.dart';
import '../entities/path_stage.dart';
import '../entities/learning_task.dart';
import '../entities/progress.dart';

abstract class LearningPathRepository {
  // 学习路径相关操作
  Future<LearningPath> createLearningPath(LearningPath path);
  Future<List<LearningPath>> getUserLearningPaths(String userId);
  
  // 学习阶段相关操作
  Future<PathStage> createPathStage(PathStage stage);
  Future<List<PathStage>> getPathStages(String pathId);
  
  // 学习任务相关操作
  Future<LearningTask> createLearningTask(LearningTask task);
  Future<List<LearningTask>> getStageTasks(String stageId);
  
  // 学习进度相关操作
  Future<Progress> createProgress(Progress progress);
  Future<List<Progress>> getUserProgress(String userId);
} 