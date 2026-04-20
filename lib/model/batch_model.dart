import 'package:tutionsapp/model/employee_model.dart';

class batch {
  final String id;
  final String name;
  final int total;

  batch({required this.id, required this.name, required this.total});

  batch copyWith({String? id, String? name, int? total}) {
    return batch(
      id: id ?? this.id,
      name: name ?? this.name,
      total: total ?? this.total,
    );
  }

  factory batch.fromMap(Map<String, dynamic> map, String id) {
    return batch(id: id, name: map['name'] ?? '', total: map['total'] ?? 0);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'total': total};
  }
}
