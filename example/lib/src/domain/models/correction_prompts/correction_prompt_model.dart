class CorrectionPromptModel {
  const CorrectionPromptModel({
    required this.correctionPromptId,
    required this.reportId,
    required this.title,
    required this.prompt,
    required this.primaryColor,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.description,
  });

  final String correctionPromptId;
  final String reportId;
  final String title;
  final String prompt;
  final int primaryColor;
  final String status;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  CorrectionPromptModel copyWith({
    String? title,
    String? prompt,
    String? description,
    int? primaryColor,
    String? status,
    DateTime? updatedAt,
    bool clearDescription = false,
  }) {
    return CorrectionPromptModel(
      correctionPromptId: correctionPromptId,
      reportId: reportId,
      title: title ?? this.title,
      prompt: prompt ?? this.prompt,
      description: clearDescription ? null : (description ?? this.description),
      primaryColor: primaryColor ?? this.primaryColor,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'correctionPromptId': correctionPromptId,
      'reportId': reportId,
      'title': title,
      'prompt': prompt,
      'description': description,
      'primaryColor': primaryColor,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory CorrectionPromptModel.fromMap(Map<String, dynamic> map) {
    return CorrectionPromptModel(
      correctionPromptId: map['correctionPromptId'] as String? ?? '',
      reportId: map['reportId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      prompt: map['prompt'] as String? ?? '',
      description: _asDescription(map['description']),
      primaryColor: _asColorInt(map['primaryColor']),
      status: map['status'] as String? ?? '',
      createdAt: _asDateTime(map['createdAt']),
      updatedAt: _asDateTime(map['updatedAt']),
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
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return parsed.toUtc();
      }
    }
    return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }
}
