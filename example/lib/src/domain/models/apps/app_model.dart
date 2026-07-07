class AppModel {
  const AppModel({
    required this.appId,
    required this.workspaceId,
    required this.name,
    required this.primaryColor,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.description,
  });

  final String appId;
  final String workspaceId;
  final String name;
  final String? description;
  final int primaryColor;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppModel copyWith({
    String? name,
    String? description,
    int? primaryColor,
    String? status,
    DateTime? updatedAt,
    bool clearDescription = false,
  }) {
    return AppModel(
      appId: appId,
      workspaceId: workspaceId,
      name: name ?? this.name,
      description: clearDescription ? null : (description ?? this.description),
      primaryColor: primaryColor ?? this.primaryColor,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appId': appId,
      'workspaceId': workspaceId,
      'name': name,
      'description': description,
      'primaryColor': primaryColor,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory AppModel.fromMap(Map<String, dynamic> map) {
    return AppModel(
      appId: map['appId'] as String? ?? '',
      workspaceId: map['workspaceId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      description: _asDescription(map['description']),
      primaryColor: _asColorInt(map['primaryColor']),
      status: map['status'] as String? ?? '',
      createdAt: _asDateTime(map['createdAt']),
      updatedAt: _asDateTime(map['updatedAt']),
    );
  }

  static int _asColorInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value) ?? 0xFF0F766E;
    }
    return 0xFF0F766E;
  }

  static String? _asDescription(dynamic value) {
    if (value == null) {
      return null;
    }
    final text = value.toString().trim();
    if (text.isEmpty) {
      return null;
    }
    return text;
  }

  static DateTime _asDateTime(dynamic value) {
    if (value is DateTime) {
      return value.toUtc();
    }
    if (value != null && value.runtimeType.toString() == 'Timestamp') {
      final dateTime = (value as dynamic).toDate() as DateTime;
      return dateTime.toUtc();
    }
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return parsed.toUtc();
      }
    }
    return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }
}
