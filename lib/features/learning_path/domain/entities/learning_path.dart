import 'package:freezed_annotation/freezed_annotation.dart';

part 'learning_path.freezed.dart';
part 'learning_path.g.dart';

@freezed
class LearningPath with _$LearningPath {
  const factory LearningPath({
    required String id,
    required String userId,
    required String title,
    required String description,
    required List<String> targetSkills,
    required int estimatedDuration,
    required String difficulty,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _LearningPath;

  factory LearningPath.fromJson(Map<String, dynamic> json) =>
      _$LearningPathFromJson(json);
} 