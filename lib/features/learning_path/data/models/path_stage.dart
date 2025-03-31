class PathStage {
  final String id;
  final String pathId;
  final String title;
  final String description;
  final int order;
  final int duration;
  final String? prerequisites;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  PathStage({
    required this.id,
    required this.pathId,
    required this.title,
    required this.description,
    required this.order,
    required this.duration,
    this.prerequisites,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PathStage.fromJson(Map<String, dynamic> json) => PathStage(
    id: json['id'],
    pathId: json['path_id'],
    title: json['title'],
    description: json['description'],
    order: json['order'],
    duration: json['duration'] ?? 30,
    prerequisites: json['prerequisites'],
    status: json['status'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'path_id': pathId,
    'title': title,
    'description': description,
    'order': order,
    'duration': duration,
    'prerequisites': prerequisites,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  PathStage copyWith({
    String? id,
    String? pathId,
    String? title,
    String? description,
    int? order,
    int? duration,
    String? prerequisites,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PathStage(
    id: id ?? this.id,
    pathId: pathId ?? this.pathId,
    title: title ?? this.title,
    description: description ?? this.description,
    order: order ?? this.order,
    duration: duration ?? this.duration,
    prerequisites: prerequisites ?? this.prerequisites,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
} 