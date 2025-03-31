import 'package:freezed_annotation/freezed_annotation.dart';

part 'progress.freezed.dart';
part 'progress.g.dart';

@freezed
class Progress with _$Progress {
  const factory Progress({
    required String id,
    required String userId,
    required String pathId,
    required String taskId,
    required String status,
    required DateTime startTime,
    DateTime? completionTime,
    String? notes,
    String? feedback,
  }) = _Progress;

  factory Progress.fromJson(Map<String, dynamic> json) =>
      _$ProgressFromJson(json);
} 