class Workspace {
  const Workspace({
    required this.workspaceId,
    required this.name,
    required this.ownerUserId,
    required this.ownerEmail,
    required this.primaryColor,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.description,
  });

  final String workspaceId;
  final String name;
  final String ownerUserId;
  final String ownerEmail;
  final String? description;
  final int primaryColor;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;

  Workspace copyWith({
    String? name,
    String? description,
    String? status,
    int? primaryColor,
    DateTime? updatedAt,
    bool clearDescription = false,
  }) {
    return Workspace(
      workspaceId: workspaceId,
      name: name ?? this.name,
      ownerUserId: ownerUserId,
      ownerEmail: ownerEmail,
      description: clearDescription ? null : (description ?? this.description),
      primaryColor: primaryColor ?? this.primaryColor,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'workspaceId': workspaceId,
      'name': name,
      'ownerUserId': ownerUserId,
      'ownerEmail': ownerEmail,
      'description': description,
      'primaryColor': primaryColor,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'status': status,
    };
  }

  factory Workspace.fromMap(Map<String, dynamic> map) {
    return Workspace(
      workspaceId: map['workspaceId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      ownerUserId: map['ownerUserId'] as String? ?? '',
      ownerEmail: map['ownerEmail'] as String? ?? '',
      description: _asDescription(map['description']),
      primaryColor: _asColorInt(map['primaryColor']),
      createdAt: _asDateTime(map['createdAt']),
      updatedAt: _asDateTime(map['updatedAt']),
      status: map['status'] as String? ?? '',
    );
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

  static int _asColorInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value) ?? 0xFF0F766E;
    }
    return 0xFF0F766E;
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
      return DateTime.tryParse(value)?.toUtc() ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    }
    return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }
}
