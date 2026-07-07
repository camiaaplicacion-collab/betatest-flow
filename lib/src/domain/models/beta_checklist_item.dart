class BetaChecklistItem {
  const BetaChecklistItem({
    required this.id,
    required this.title,
    this.description,
    this.required = false,
    this.sortOrder = 0,
  });

  final String id;
  final String title;
  final String? description;
  final bool required;
  final int sortOrder;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'required': required,
      'sortOrder': sortOrder,
    };
  }

  factory BetaChecklistItem.fromMap(Map<String, dynamic> map) {
    return BetaChecklistItem(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      required: map['required'] as bool? ?? false,
      sortOrder: map['sortOrder'] as int? ?? 0,
    );
  }
}