import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/learning_path.dart';
import '../../data/models/path_stage.dart';
import '../../data/models/learning_task.dart';
import '../../data/repositories/learning_path_repository.dart';
import 'learning_path_state.dart';

class LearningPathNotifier extends StateNotifier<LearningPathState> {
  final LearningPathRepository _repository;

  LearningPathNotifier(this._repository) : super(const LearningPathState.initial());

  Future<void> getPaths(String userId) async {
    state = const LearningPathState.loading();
    try {
      final paths = await _repository.getPaths(userId);
      state = LearningPathState.loaded(paths: paths);
    } catch (e) {
      state = LearningPathState.error(e.toString());
    }
  }

  Future<void> getPathDetail(String pathId) async {
    state = const LearningPathState.loading();
    try {
      final path = await _repository.getPath(pathId);
      final stages = await _repository.getStages(pathId);
      final tasks = await _repository.getTasks(pathId);
      final progress = await _repository.getProgress(pathId);
      state = LearningPathState.pathDetail(
        path: path,
        stages: stages,
        tasks: tasks,
        progress: progress,
      );
    } catch (e) {
      state = LearningPathState.error(e.toString());
    }
  }

  Future<void> createPath(LearningPath path) async {
    state = const LearningPathState.loading();
    try {
      await _repository.createPath(path);
      final paths = await _repository.getPaths(path.userId);
      state = LearningPathState.loaded(paths: paths);
    } catch (e) {
      state = LearningPathState.error(e.toString());
    }
  }

  Future<void> updatePath(LearningPath path) async {
    state = const LearningPathState.loading();
    try {
      await _repository.updatePath(path);
      final paths = await _repository.getPaths(path.userId);
      state = LearningPathState.loaded(paths: paths);
    } catch (e) {
      state = LearningPathState.error(e.toString());
    }
  }

  Future<PathStage> createStage(PathStage stage) async {
    try {
      return await _repository.createStage(stage);
    } catch (e) {
      state = LearningPathState.error(e.toString());
      rethrow;
    }
  }

  Future<LearningTask> createTask(LearningTask task) async {
    try {
      return await _repository.createTask(task);
    } catch (e) {
      state = LearningPathState.error(e.toString());
      rethrow;
    }
  }
} 