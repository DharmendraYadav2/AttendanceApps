import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tutionsapp/model/attendence_model.dart';
import 'package:tutionsapp/model/attendence_report_model.dart';
import 'package:tutionsapp/model/batch_model.dart';
import 'package:tutionsapp/model/employee_model.dart';

import '../../model/attendece_table.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._auth, this._firestore);

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      final uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'user_id': uid,
        'created_at': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw e.code;
    }
  }

  Future<void> loginup({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw e.code;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  //----batches----------//
  Future<void> createBatch(batch b) async {
    final user = _auth.currentUser;
    if (user == null) throw "User not logged in";

    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("batches")
        .doc(b.id)
        .set({'id': b.id, 'name': b.name});
  }

  Future<List<batch>> getbatch() async {
    final user = _auth.currentUser;
    if (user == null) throw "User not logged in";

    final batchSnap = await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("batches")
        .get();

    List<batch> batchList = [];

    for (var doc in batchSnap.docs) {
      final empSnap = await doc.reference.collection("employees").get();

      batchList.add(
        batch(id: doc.id, name: doc['name'] ?? '', total: empSnap.docs.length),
      );
    }

    return batchList;
  }

  Future<void> updateBatch(batch b) async {
    final user = _auth.currentUser;
    if (user == null) throw "User not logged in";

    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("batches")
        .doc(b.id)
        .update({'name': b.name});
  }

  Future<void> deletebatch(String id) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw "User not logged in";
      await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("batches")
          .doc(id)
          .delete();
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Delete failed";
    }
  }

  //---employee addd---//
  Future<void> addemployee(String batchId, Employee emp) async {
    final user = _auth.currentUser;
    if (user == null) throw "user not found";

    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("batches")
        .doc(batchId)
        .collection("employees")
        .doc(emp.id)
        .set(emp.toMap());
  }

  Future<List<Employee>> getemployee(String batchId) async {
    final user = _auth.currentUser;
    if (user == null) throw "User not logged in";

    final snap = await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("batches")
        .doc(batchId)
        .collection("employees")
        .get();

    return snap.docs.map((doc) {
      final e = doc.data();
      return Employee(
        id: doc.id,
        name: e['name'] ?? '',
        phone: e['phone'] ?? 0,
        daily: e['daily'] ?? 0,
      );
    }).toList();
  }

  Future<void> editEmployee(String batchId, Employee emp) async {
    final user = _auth.currentUser;
    if (user == null) throw "User not logged in";

    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("batches")
        .doc(batchId)
        .collection("employees")
        .doc(emp.id)
        .update(emp.toMap());
  }

  Future<void> deleteEmployee(String batchId, String empId) async {
    final user = _auth.currentUser;
    if (user == null) throw "User not logged in";

    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("batches")
        .doc(batchId)
        .collection("employees")
        .doc(empId)
        .delete();
  }

  //---attendence---//
  Future<void> addOrUpdateAttendance({
    required String batchId,
    required String empId,
    required Attendence attendance,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw "User not logged in";

    final docRef = _firestore
        .collection("users")
        .doc(user.uid)
        .collection("batches")
        .doc(batchId)
        .collection("employees")
        .doc(empId)
        .collection("attendance")
        .doc(attendance.id);

    await docRef.set({
      "date": attendance.date,
      "status": attendance.status,
      "type": attendance.type,
      "paid": attendance.paid,
      "totalSalary": attendance.totalSalary,
    }, SetOptions(merge: true));
  }

  Future<AttendanceSummary> calculateSummary(
    List<Attendence> attendanceList,
  ) async {
    int presentDays = 0;
    int absentDays = 0;

    double totalSalary = 0;
    double paid = 0;

    for (var att in attendanceList) {
      if (att.status == "P") {
        presentDays++;
      } else {
        absentDays++;
      }

      totalSalary += att.totalSalary;

      paid += att.paid;
    }

    double remaining = totalSalary - paid;

    return AttendanceSummary(
      presentDays: presentDays,
      absentDays: absentDays,
      totalSalary: totalSalary,
      paid: paid,
      remaining: remaining,
    );
  }

  Future<List<AttendanceRow>> getEmployeeAttendanceList({
    required String batchId,
    required String empId,
    required int month,
    required int year,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw "User not logged in";

    final snap = await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("batches")
        .doc(batchId)
        .collection("employees")
        .doc(empId)
        .collection("attendance")
        .get();

    return snap.docs
        .where((doc) {
          final data = doc.data();

          final date = DateTime.tryParse(data["date"] ?? "");

          if (date == null) return false;

          return date.month == month && date.year == year;
        })
        .map((doc) {
          final data = doc.data();

          return AttendanceRow(
            date: data["date"] ?? "",
            status: data["status"] ?? "",
            paid: (data["paid"] ?? 0).toInt(),
            type: data["type"] ?? "",
            totalSalary: (data["totalSalary"] ?? 0).toDouble(), // ✅ FIX
          );
        })
        .toList();
  }
}
