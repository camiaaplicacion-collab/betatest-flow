class TesterModel {
  const TesterModel({
    required this.testerId,
    required this.betaId,
    required this.displayName,
    required this.email,
    required this.primaryColor,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String testerId;
  final String betaId;
  final String displayName;
  final String email;
  final int primaryColor;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  TesterModel copyWith({
    String? displayName,
    String? email,
    int? primaryColor,
    String? status,
    DateTime? updatedAt,
  }) {
    return TesterModel(
      testerId: testerId,
      betaId: betaId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      primaryColor: primaryColor ?? this.primaryColor,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'testerId': testerId,
      'betaId': betaId,
      'displayName': displayName,
      'email': email,
      'primaryColor': primaryColor,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory TesterModel.fromMap(Map<String, dynamic> map) {
    return TesterModel(
      testerId: map['testerId'] as String? ?? '',
      betaId: map['betaId'] as String? ?? '',
      displayName: map['displayName'] as String? ?? '',
      email: map['email'] as String? ?? '',
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
