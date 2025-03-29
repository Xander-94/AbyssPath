class User { // 用户实体类
  final String id; // 用户ID
  final String email; // 邮箱
  final String? name; // 姓名
  final String? avatar; // 头像URL
  final bool isEmailVerified; // 邮箱是否验证
  final DateTime createdAt; // 创建时间
  final DateTime updatedAt; // 更新时间
  final DateTime? lastLoginAt; // 最后登录时间
  final Map<String, dynamic>? metadata; // 元数据

  const User({ // 构造函数
    required this.id,
    required this.email,
    this.name,
    this.avatar,
    required this.isEmailVerified,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
    this.metadata,
  });

  factory User.fromJson(Map<String, dynamic> json) { // 从JSON创建用户实体
    return User( // 返回用户实体
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      isEmailVerified: json['email_confirmed_at'] != null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastLoginAt: json['last_sign_in_at'] != null ? DateTime.parse(json['last_sign_in_at'] as String) : null,
      metadata: json['user_metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() { // 转换为JSON
    return { // 返回JSON
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'email_confirmed_at': isEmailVerified ? DateTime.now().toIso8601String() : null,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_sign_in_at': lastLoginAt?.toIso8601String(),
      'user_metadata': metadata,
    };
  }

  User copyWith({ // 复制方法
    String? id,
    String? email,
    String? name,
    String? avatar,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? metadata,
  }) {
    return User( // 返回新实例
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      metadata: metadata ?? this.metadata,
    );
  }
} 