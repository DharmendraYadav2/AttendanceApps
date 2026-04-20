import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:tutionsapp/Service/Firebase/app_firebase.dart';
import 'package:tutionsapp/Service/Firebase/providers/signup.dart';
import 'package:tutionsapp/model/attendence_model.dart';
import 'package:tutionsapp/model/attendence_report_model.dart';
import 'package:tutionsapp/model/batch_model.dart';
import 'package:tutionsapp/model/employee_model.dart';

final empcontrlprovider =
    StateNotifierProvider<employeecontroller, AsyncValue<List<Employee>>>((
      ref,
    ) {
      return employeecontroller(ref.read(authrepositoryprovider));
    });

class employeecontroller extends StateNotifier<AsyncValue<List<Employee>>> {
  final AuthRepository _repo;
  employeecontroller(this._repo) : super(AsyncValue.loading());
  String? _currentBatchId;

  Future<void> loademp(String batchid) async {
    try {
      _currentBatchId = batchid;
      state = const AsyncValue.loading();

      final data = await _repo.getemployee(batchid);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addemp(String id, Employee emp) async {
    try {
      await _repo.addemployee(id, emp);
      await loademp(id);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> editemp(String batchId, Employee updatedEmp) async {
    try {
      await _repo.editEmployee(batchId, updatedEmp);
      await loademp(batchId);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteemp(String batchId, String employeeId) async {
    try {
      await _repo.deleteEmployee(batchId, employeeId);
      await loademp(batchId);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markAttendance({
    required String batchId,
    required String empId,
    required Attendence attendance,
  }) async {
    try {
      await _repo.addOrUpdateAttendance(
        batchId: batchId,
        empId: empId,
        attendance: attendance,
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateAttendance({
    required String batchId,
    required String empId,
    required Attendence attendance,
  }) async {
    try {
      await _repo.addOrUpdateAttendance(
        batchId: batchId,
        empId: empId,
        attendance: attendance,
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
