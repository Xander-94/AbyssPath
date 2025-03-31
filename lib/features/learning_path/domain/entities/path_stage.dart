import 'package:freezed_annotation/freezed_annotation.dart';

part 'path_stage.freezed.dart';
part 'path_stage.g.dart';

@freezed
class PathStage with _$PathStage {
  const factory PathStage({
    required String id,
    required String pathId,
    required String name,
    required String description,
    required int duration,
    required List<String> prerequisites,
    required int order,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PathStage;

  factory PathStage.fromJson(Map<String, dynamic> json) =>
      _$PathStageFromJson(json);
} 