class Attendence {
  final String id;
  final String date;
  final String status;
  final int paid;
  final String type;
  final int totalSalary;
  Attendence({
    required this.id,
    required this.date,
    required this.status,
    required this.paid,
    required this.type,
    required this.totalSalary,
  });
  Attendence copyWith({
    String? id,
    String? date,
    String? status,
    int? paid,
    String? type,
    int? totalSalary,
  }) {
    return Attendence(
      id: id ?? this.id,
      date: date ?? this.date,
      status: status ?? this.status,
      paid: paid ?? this.paid,
      type: type ?? this.type,
      totalSalary: totalSalary ?? this.totalSalary,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'status': status,
      'paid': paid,
      'type': type,
      'totalSalary': totalSalary,
    };
  }

  factory Attendence.fromMap(Map<String, dynamic> map) {
    return Attendence(
      id: map['id'],
      date: map['date'],
      status: map['status'],
      paid: map['paid'],
      type: map['type'],
      totalSalary: map['totalSalary'],
    );
  }
}
