enum NotificationType {
  order,
  promotion,
  system,
}

class Notification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final bool read;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.read = false,
    required this.createdAt,
    this.data,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationType.values.firstWhere((e) => e.toString() == json['type']),
      read: json['read'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.toString(),
      'read': read,
      'createdAt': createdAt.toIso8601String(),
      'data': data,
    };
  }

  Notification copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    bool? read,
    DateTime? createdAt,
    Map<String, dynamic>? data,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
    );
  }
}
