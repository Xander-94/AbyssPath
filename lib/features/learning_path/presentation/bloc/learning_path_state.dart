import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/learning_path.dart';
import '../../data/models/path_stage.dart';
import '../../data/models/learning_task.dart';

part 'learning_path_state.freezed.dart';

@freezed
class LearningPathState with _$LearningPathState {
  const factory LearningPathState.initial() = _Initial;
  const factory LearningPathState.loading() = _Loading;
  const factory LearningPathState.error(String message) = _Error;
  const factory LearningPathState.loaded({
    required List<LearningPath> paths,
  }) = _Loaded;
  const factory LearningPathState.pathDetail({
    required LearningPath path,
    required List<PathStage> stages,
    required List<LearningTask> tasks,
    required Map<String, double> progress,
  }) = _PathDetail;
} 