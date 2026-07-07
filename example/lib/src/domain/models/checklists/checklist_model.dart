class ChecklistModel {
  const ChecklistModel({
    required this.checklistId,
    required this.goalId,
    required this.title,
    required this.primaryColor,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.description,
  });

  final String checklistId;
  final String goalId;
  final String title;
  final String? description;
  final int primaryColor;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChecklistModel copyWith({
    String? title,
    String? description,
    int? primaryColor,
    String? status,
    DateTime? updatedAt,
    bool clearDescription = false,
  }) {
    return ChecklistModel(
      checklistId: checklistId,
      goalId: goalId,
      title: title ?? this.title,
      description: clearDescription ? null : (description ?? this.description),
      primaryColor: primaryColor ?? this.primaryColor,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'checklistId': checklistId,
      'goalId': goalId,
      'title': title,
      'description': description,
      'primaryColor': primaryColor,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ChecklistModel.fromMap(Map<String, dynamic> map) {
    return ChecklistModel(
      checklistId: map['checklistId'] as String? ?? '',
      goalId: map['goalId'] as String? ?? '',
      title: map['title'] as String? ?? '',
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