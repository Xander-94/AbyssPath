import 'package:freezed_annotation/freezed_annotation.dart'; // 导入freezed注解

part 'assessment.freezed.dart'; // 生成freezed代码

@freezed
class Assessment with _$Assessment { // 评估实体
  const factory Assessment({
    required String id, // 评估ID
    required String userId, // 用户ID
    required DateTime startTime, // 开始时间
    required List<Interaction> interactions, // 互动记录
    UserProfile? userProfile, // 用户画像
  }) = _Assessment;
}

@freezed
class Interaction with _$Interaction { // 互动实体
  const factory Interaction({
    required String question, // 问题
    required String userResponse, // 用户回答
    required DateTime timestamp, // 时间戳
    Map<String, double>? traits, // 特征分析
  }) = _Interaction;
}

@freezed
class UserProfile with _$UserProfile { // 用户画像实体
  const factory UserProfile({
    required Map<String, double> hardSkills, // 硬核能力
    required Map<String, double> metaSkills, // 元能力
    required Map<String, double> influence, // 影响力
    required String summary, // 总结
    required List<String> skillTypes, // 技能种类
    required Map<String, double> skillProficiency, // 技能熟练程度
    required List<String> interests, // 兴趣爱好
  }) = _UserProfile;
} 