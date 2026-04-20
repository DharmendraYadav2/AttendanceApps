import 'package:tutionsapp/model/attendence_model.dart';

class Employee {
  final String id;
  final String name;
  final int phone;
  final int daily;
  Employee({
    required this.id,
    required this.name,
    required this.daily,
    required this.phone,
  });

  Employee copyWith({String? id, String? name, int? total, int? phone}) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      daily: total ?? this.daily,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'phone': phone, 'daily': daily};
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      daily: map['daily'],
    );
  }
}
