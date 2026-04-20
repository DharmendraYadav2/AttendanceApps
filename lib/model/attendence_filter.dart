class AttendanceFilter {
  final String batchId;
  final String empId;
  final int month;
  final int year;

  AttendanceFilter({
    required this.batchId,
    required this.empId,
    required this.month,
    required this.year,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceFilter &&
          runtimeType == other.runtimeType &&
          batchId == other.batchId &&
          empId == other.empId &&
          month == other.month &&
          year == other.year;

  @override
  int get hashCode =>
      batchId.hashCode ^ empId.hashCode ^ month.hashCode ^ year.hashCode;
}
