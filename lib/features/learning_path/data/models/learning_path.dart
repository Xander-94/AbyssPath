class LearningPath {
  final String id;
  final String userId;
  final String title;
  final String description;
  final List<String> targetSkills;
  final String estimatedDuration;
  final String difficulty;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  LearningPath({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.targetSkills,
    required this.estimatedDuration,
    required this.difficulty,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LearningPath.fromJson(Map<String, dynamic> json) => LearningPath(
    id: json['id'],
    userId: json['user_id'],
    title: json['title'],
    description: json['description'],
    targetSkills: List<String>.from(json['target_skills']),
    estimatedDuration: json['estimated_duration'],
    difficulty: json['difficulty'],
    status: json['status'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'title': title,
    'description': description,
    'target_skills': targetSkills,
    'estimated_duration': estimatedDuration,
    'difficulty': difficulty,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  LearningPath copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    List<String>? targetSkills,
    String? estimatedDuration,
    String? difficulty,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LearningPath(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    description: description ?? this.description,
    targetSkills: targetSkills ?? this.targetSkills,
    estimatedDuration: estimatedDuration ?? this.estimatedDuration,
    difficulty: difficulty ?? this.difficulty,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
} 