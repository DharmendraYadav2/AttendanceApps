class AttendanceSummary {
  final int presentDays;
  final int absentDays;
  final double totalSalary;
  final double paid;
  final double remaining;

  AttendanceSummary({
    required this.presentDays,
    required this.absentDays,
    required this.totalSalary,
    required this.paid,
    required this.remaining,
  });
}
