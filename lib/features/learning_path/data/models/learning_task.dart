class LearningTask {
  final String id;
  final String stageId;
  final String title;
  final String description;
  final int order;
  final String type;
  final String status;
  final DateTime? deadline;
  final double progress;
  final DateTime createdAt;
  final DateTime updatedAt;

  LearningTask({
    required this.id,
    required this.stageId,
    required this.title,
    required this.description,
    required this.order,
    required this.type,
    required this.status,
    this.deadline,
    required this.progress,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LearningTask.fromJson(Map<String, dynamic> json) => LearningTask(
    id: json['id'],
    stageId: json['stage_id'],
    title: json['title'],
    description: json['description'],
    order: json['order'],
    type: json['type'],
    status: json['status'],
    deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
    progress: (json['progress'] ?? 0).toDouble(),
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'stage_id': stageId,
    'title': title,
    'description': description,
    'order': order,
    'type': type,
    'status': status,
    'deadline': deadline?.toIso8601String(),
    'progress': progress,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  LearningTask copyWith({
    String? id,
    String? stageId,
    String? title,
    String? description,
    int? order,
    String? type,
    String? status,
    DateTime? deadline,
    double? progress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LearningTask(
    id: id ?? this.id,
    stageId: stageId ?? this.stageId,
    title: title ?? this.title,
    description: description ?? this.description,
    order: order ?? this.order,
    type: type ?? this.type,
    status: status ?? this.status,
    deadline: deadline ?? this.deadline,
    progress: progress ?? this.progress,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
} 