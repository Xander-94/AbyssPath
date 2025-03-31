import 'package:freezed_annotation/freezed_annotation.dart';

part 'learning_task.freezed.dart';
part 'learning_task.g.dart';

@freezed
class LearningTask with _$LearningTask {
  const factory LearningTask({
    required String id,
    required String stageId,
    required String name,
    required String description,
    required String type,
    required DateTime deadline,
    required double progress,
    required int order,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _LearningTask;

  factory LearningTask.fromJson(Map<String, dynamic> json) =>
      _$LearningTaskFromJson(json);
} 