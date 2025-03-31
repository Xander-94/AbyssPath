import 'package:freezed_annotation/freezed_annotation.dart'; // 导入freezed注解
import '../../domain/entities/assessment.dart'; // 导入评估实体

part 'assessment_state.freezed.dart'; // 生成freezed代码

@freezed
class AssessmentState with _$AssessmentState { // 评估状态
  const factory AssessmentState.initial() = _Initial; // 初始状态
  const factory AssessmentState.loading() = _Loading; // 加载状态
  const factory AssessmentState.inProgress({ // 进行中状态
    required Assessment session,
    required String currentQuestion,
    required double progress,
  }) = _InProgress;
  const factory AssessmentState.completed({ // 完成状态
    required Assessment session,
  }) = _Completed;
  const factory AssessmentState.error(String message) = _Error; // 错误状态
} 