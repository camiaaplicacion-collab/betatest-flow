class ReportModel {
  const ReportModel({
    required this.reportId,
    required this.resultId,
    required this.title,
    required this.primaryColor,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.summary,
    this.description,
  });

  final String reportId;
  final String resultId;
  final String title;
  final int primaryColor;
  final String status;
  final String? summary;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReportModel copyWith({
    String? title,
    String? status,
    String? summary,
    String? description,
    int? primaryColor,
    DateTime? updatedAt,
    bool clearSummary = false,
    bool clearDescription = false,
  }) {
    return ReportModel(
      reportId: reportId,
      resultId: resultId,
      title: title ?? this.title,
      primaryColor: primaryColor ?? this.primaryColor,
      status: status ?? this.status,
      summary: clearSummary ? null : (summary ?? this.summary),
      description: clearDescription ? null : (description ?? this.description),
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reportId': reportId,
      'resultId': resultId,
      'title': title,
      'primaryColor': primaryColor,
      'status': status,
      'summary': summary,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      reportId: map['reportId'] as String? ?? '',
      resultId: map['resultId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      primaryColor: _asColorInt(map['primaryColor']),
      status: map['status'] as String? ?? '',
      summary: _asSummary(map['summary']),
      description: _asDescription(map['description']),
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

  static String? _asSummary(dynamic value) {
    if (value == null) {
      return null;
    }
    final text = value.toString().trim();
    if (text.isEmpty) {
      return null;
    }
    return text;
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
