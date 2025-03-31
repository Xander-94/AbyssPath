# 学习路径模块

## 功能概述
学习路径模块负责管理用户的学习计划，包括路径的生成、展示、更新和进度追踪。

## 已实现功能
1. 路径管理
   - 路径列表展示
   - 路径详情查看
   - 路径生成（基于用户目标）
   - UUID 支持
   - 数据类型转换优化

2. 数据持久化
   - Supabase 集成
   - PostgreSQL 数据库支持
   - 数据模型定义
   - 数据转换层实现

3. 状态管理
   - Riverpod 状态管理
   - 路径状态监听
   - 错误处理机制

4. UI 实现
   - 路径列表页面
   - 路径详情页面
   - 路径生成页面
   - 加载状态展示
   - 错误提示

## 待实现功能
1. 路径管理
   - [ ] 路径编辑功能
   - [ ] 路径删除功能
   - [ ] 路径分享功能
   - [ ] 路径复制功能
   - [ ] 路径标签管理

2. 学习进度
   - [ ] 进度追踪系统
   - [ ] 里程碑设置
   - [ ] 完成度统计
   - [ ] 学习时间记录
   - [ ] 进度分析报告

3. 资源管理
   - [ ] 学习资源推荐
   - [ ] 资源收藏功能
   - [ ] 资源评分系统
   - [ ] 资源分享功能

4. 社交功能
   - [ ] 学习小组
   - [ ] 评论系统
   - [ ] 点赞功能
   - [ ] 关注系统

## 数据模型
```dart
// 学习路径
class LearningPath {
  String id;
  String userId;
  String title;
  String description;
  List<String> targetSkills;
  int estimatedDuration;
  String difficulty;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
}

// 学习阶段
class PathStage {
  String id;
  String pathId;
  String name;
  String description;
  int duration;
  List<String> prerequisites;
  int order;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
}

// 学习任务
class LearningTask {
  String id;
  String stageId;
  String name;
  String description;
  String type;
  DateTime deadline;
  double progress;
  int order;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
}

// 学习进度
class Progress {
  String id;
  String userId;
  String pathId;
  String taskId;
  String status;
  DateTime startTime;
  DateTime? completionTime;
  String? notes;
  String? feedback;
}
```

## 最近更新
1. 修复了 UUID 类型转换问题
   - 添加了 UUID 类型支持
   - 优化了数据转换逻辑
   - 改进了错误处理

2. 改进了数据持久化
   - 优化了数据库操作
   - 添加了事务支持
   - 完善了错误处理

3. 优化了用户体验
   - 添加了加载状态展示
   - 改进了错误提示
   - 优化了页面切换动画

## 开发注意事项
1. 数据处理
   - 所有数据库操作需要添加错误处理
   - 使用事务确保数据一致性
   - 注意数据类型转换

2. 状态管理
   - 使用 Riverpod 管理状态
   - 避免状态冗余
   - 及时释放资源

3. UI 开发
   - 遵循 Material Design 3 规范
   - 注意性能优化
   - 保持代码整洁

4. 测试
   - 编写单元测试
   - 添加集成测试
   - 进行性能测试 