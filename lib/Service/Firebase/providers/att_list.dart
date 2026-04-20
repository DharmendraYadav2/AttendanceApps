import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutionsapp/Service/Firebase/providers/signup.dart';

import '../../../model/attendece_table.dart';
import '../../../model/attendence_filter.dart';

final attendanceListProvider =
    FutureProvider.family<List<AttendanceRow>, AttendanceFilter>((
      ref,
      filter,
    ) async {
      final repo = ref.read(authrepositoryprovider);

      return repo.getEmployeeAttendanceList(
        batchId: filter.batchId,
        empId: filter.empId,
        month: filter.month,
        year: filter.year,
      );
    });
