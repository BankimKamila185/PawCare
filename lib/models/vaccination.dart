class Vaccination {
  final String id;
  final String vaccineName;
  final DateTime dateGiven;
  final DateTime nextDueDate;
  final String notes;
  final String category; // e.g. 'Booster', 'Core', 'Initial Immunization'
  final bool isCompleted;

  const Vaccination({
    required this.id,
    required this.vaccineName,
    required this.dateGiven,
    required this.nextDueDate,
    this.notes = '',
    this.category = 'Core',
    this.isCompleted = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vaccineName': vaccineName,
      'dateGiven': dateGiven.toIso8601String(),
      'nextDueDate': nextDueDate.toIso8601String(),
      'notes': notes,
      'category': category,
      'isCompleted': isCompleted,
    };
  }

  factory Vaccination.fromJson(Map<String, dynamic> json) {
    return Vaccination(
      id: json['id'] as String? ?? '',
      vaccineName: json['vaccineName'] as String? ?? '',
      dateGiven: json['dateGiven'] != null
          ? DateTime.tryParse(json['dateGiven'] as String) ?? DateTime.now()
          : DateTime.now(),
      nextDueDate: json['nextDueDate'] != null
          ? DateTime.tryParse(json['nextDueDate'] as String) ??
              DateTime.now().add(const Duration(days: 365))
          : DateTime.now().add(const Duration(days: 365)),
      notes: json['notes'] as String? ?? '',
      category: json['category'] as String? ?? 'Core',
      isCompleted: json['isCompleted'] as bool? ?? true,
    );
  }

  Vaccination copyWith({
    String? id,
    String? vaccineName,
    DateTime? dateGiven,
    DateTime? nextDueDate,
    String? notes,
    String? category,
    bool? isCompleted,
  }) {
    return Vaccination(
      id: id ?? this.id,
      vaccineName: vaccineName ?? this.vaccineName,
      dateGiven: dateGiven ?? this.dateGiven,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      notes: notes ?? this.notes,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
