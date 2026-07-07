class ResultModel {
  const ResultModel({
    required this.resultId,
    required this.sdkId,
    required this.testerId,
    required this.primaryColor,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.summary,
    this.description,
  });

  final String resultId;
  final String sdkId;
  final String testerId;
  final int primaryColor;
  final String status;
  final String? summary;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  ResultModel copyWith({
    String? status,
    String? summary,
    String? description,
    int? primaryColor,
    DateTime? updatedAt,
    bool clearSummary = false,
    bool clearDescription = false,
  }) {
    return ResultModel(
      resultId: resultId,
      sdkId: sdkId,
      testerId: testerId,
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
      'resultId': resultId,
      'sdkId': sdkId,
      'testerId': testerId,
      'primaryColor': primaryColor,
      'status': status,
      'summary': summary,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ResultModel.fromMap(Map<String, dynamic> map) {
    return ResultModel(
      resultId: map['resultId'] as String? ?? '',
      sdkId: map['sdkId'] as String? ?? '',
      testerId: map['testerId'] as String? ?? '',
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
