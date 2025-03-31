import '../entities/learning_path.dart';
import '../entities/path_stage.dart';
import '../entities/learning_task.dart';
import '../entities/progress.dart';
import '../repositories/learning_path_repository.dart';

// 创建学习路径用例
class CreateLearningPathUseCase {
  final LearningPathRepository _repository;

  CreateLearningPathUseCase(this._repository);

  Future<LearningPath> call(LearningPath path) {
    return _repository.createLearningPath(path);
  }
}

// 获取用户学习路径用例
class GetUserLearningPathsUseCase {
  final LearningPathRepository _repository;

  GetUserLearningPathsUseCase(this._repository);

  Future<List<LearningPath>> call(String userId) {
    return _repository.getUserLearningPaths(userId);
  }
}

// 创建学习阶段用例
class CreatePathStageUseCase {
  final LearningPathRepository _repository;

  CreatePathStageUseCase(this._repository);

  Future<PathStage> call(PathStage stage) {
    return _repository.createPathStage(stage);
  }
}

// 获取路径阶段用例
class GetPathStagesUseCase {
  final LearningPathRepository _repository;

  GetPathStagesUseCase(this._repository);

  Future<List<PathStage>> call(String pathId) {
    return _repository.getPathStages(pathId);
  }
}

// 创建学习任务用例
class CreateLearningTaskUseCase {
  final LearningPathRepository _repository;

  CreateLearningTaskUseCase(this._repository);

  Future<LearningTask> call(LearningTask task) {
    return _repository.createLearningTask(task);
  }
}

// 获取阶段任务用例
class GetStageTasksUseCase {
  final LearningPathRepository _repository;

  GetStageTasksUseCase(this._repository);

  Future<List<LearningTask>> call(String stageId) {
    return _repository.getStageTasks(stageId);
  }
}

// 创建学习进度用例
class CreateProgressUseCase {
  final LearningPathRepository _repository;

  CreateProgressUseCase(this._repository);

  Future<Progress> call(Progress progress) {
    return _repository.createProgress(progress);
  }
}

// 获取用户进度用例
class GetUserProgressUseCase {
  final LearningPathRepository _repository;

  GetUserProgressUseCase(this._repository);

  Future<List<Progress>> call(String userId) {
    return _repository.getUserProgress(userId);
  }
} 