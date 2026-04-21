import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tutionsapp/Service/Firebase/controller/employee_ctrl.dart';
import 'package:tutionsapp/Theme/app_fonts.dart';
import 'package:tutionsapp/model/attendence_model.dart';
import 'package:tutionsapp/model/batch_model.dart';
import 'package:tutionsapp/model/employee_model.dart';
import 'package:tutionsapp/Service/Firebase/controller/batch_ctrl.dart';
import 'package:uuid/uuid.dart';

import '../model/attendece_table.dart';
import '../model/attendence_report_model.dart';

//--site----//
void showdialog(WidgetRef ref) {
  TextEditingController batch_ctrl = TextEditingController();
  final uuid = Uuid();
  Get.defaultDialog(
    backgroundColor: Colors.white,
    title: "Add Batch",
    titleStyle: AppFonts().heading.copyWith(color: Color(0xFF021B79)),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: batch_ctrl,
            decoration: InputDecoration(
              hintText: "Enter Batch",
              hintStyle: TextStyle(color: Colors.grey[500]),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFF0575E6)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () {
          Get.back();
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
        child: Text(
          "Cancel",
          style: AppFonts().heading.copyWith(
            color: Color(0xFF021B79),
            fontSize: 14,
          ),
        ),
      ),
      SizedBox(width: 40),
      ElevatedButton(
        onPressed: () async {
          var batch_s = batch_ctrl.text.trim();
          if (batch_s.isNotEmpty) {
            final newbatch = batch(id: uuid.v4(), name: batch_s, total: 0);
            await ref
                .read(batchcontrollerprovider.notifier)
                .createbatch(newbatch);

            Get.back();
          } else {
            Get.snackbar(
              'Opps !',
              "Don’t forget to add a batch name",
              colorText: Colors.white,
              isDismissible: false,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.only(bottom: 10),
              borderRadius: 0,
            );
          }
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF021B79),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),

        child: Text(
          "Save",
          style: AppFonts().heading.copyWith(color: Colors.white, fontSize: 14),
        ),
      ),
    ],
  );
}

void Editdialog(WidgetRef ref, batch batches) {
  TextEditingController editctrl = TextEditingController(text: batches.name);
  Get.defaultDialog(
    backgroundColor: Colors.white,
    title: "Edit Batch",
    titleStyle: AppFonts().heading.copyWith(color: Color(0xFF021B79)),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: editctrl,
            decoration: InputDecoration(
              hintText: "Enter Batch",
              hintStyle: TextStyle(color: Colors.grey[500]),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFF0575E6)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () {
          Get.back();
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
        child: Text(
          "Cancel",
          style: AppFonts().heading.copyWith(
            color: Color(0xFF021B79),
            fontSize: 14,
          ),
        ),
      ),
      SizedBox(width: 40),
      ElevatedButton(
        onPressed: () {
          var newname = editctrl.text.trim();
          if (newname.isNotEmpty) {
            final update = batches.copyWith(name: newname);
            ref.read(batchcontrollerprovider.notifier).createbatch(update);
            Get.back();
          }
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF021B79),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),

        child: Text(
          "Save",
          style: AppFonts().heading.copyWith(color: Colors.white, fontSize: 14),
        ),
      ),
    ],
  );
}

void delete(WidgetRef ref, String id) {
  Get.defaultDialog(
    backgroundColor: Colors.white,
    title: "Delete Batch",
    titleStyle: AppFonts().heading.copyWith(color: Color(0xFF021B79)),
    middleText: "Are you sure you want to delete?",
    actions: [
      TextButton(
        onPressed: () {
          Get.back();
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
        child: Text(
          "Cancel",
          style: AppFonts().heading.copyWith(
            color: Color(0xFF021B79),
            fontSize: 14,
          ),
        ),
      ),
      SizedBox(width: 40),
      ElevatedButton(
        onPressed: () {
          ref.read(batchcontrollerprovider.notifier).deletebatches(id);
          Get.back();

          Get.snackbar(
            'Success',
            "Deleted Successfully",
            colorText: Colors.white,
            isDismissible: false,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.only(bottom: 10),
            borderRadius: 0,
          );
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF021B79),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),

        child: Text(
          "Delete",
          style: AppFonts().heading.copyWith(color: Colors.white, fontSize: 14),
        ),
      ),
    ],
  );
}

//backbutton app close--//

void backbutton() {
  Get.defaultDialog(
    backgroundColor: Colors.white,
    radius: 12,

    title: "Exit App",
    titleStyle: AppFonts().heading.copyWith(
      color: Color(0xFF021B79),
      fontWeight: FontWeight.bold,
    ),

    middleText: "Are you sure you want to exit?",
    middleTextStyle: AppFonts().body.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    ),

    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),

    actions: [
      Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Get.back();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color(0xFF021B79)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Cancel",
                style: AppFonts().heading.copyWith(
                  color: Color(0xFF021B79),
                  fontSize: 14,
                ),
              ),
            ),
          ),

          SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                SystemNavigator.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF021B79),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Exit",
                style: AppFonts().heading.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

//---employee----//
void addempdilog(WidgetRef ref, String batchid) {
  TextEditingController addctrl = TextEditingController();
  TextEditingController mobctrl = TextEditingController();
  TextEditingController dailyctrl = TextEditingController();
  final uuid = Uuid();
  Get.defaultDialog(
    backgroundColor: Colors.white,
    title: "Add Employee",
    titleStyle: AppFonts().heading.copyWith(color: Color(0xFF021B79)),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: addctrl,
            decoration: InputDecoration(
              hintText: "Enter Name",
              hintStyle: TextStyle(color: Colors.grey[500]),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFF0575E6)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            keyboardType: TextInputType.number,
            controller: mobctrl,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: InputDecoration(
              hintText: "Enter mobile",
              hintStyle: TextStyle(color: Colors.grey[500]),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFF0575E6)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            keyboardType: TextInputType.number,
            controller: dailyctrl,
            decoration: InputDecoration(
              hintText: "Enter daily amount",
              hintStyle: TextStyle(color: Colors.grey[500]),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFF0575E6)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () {
          Get.back();
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
        child: Text(
          "Cancel",
          style: AppFonts().heading.copyWith(
            color: Color(0xFF021B79),
            fontSize: 14,
          ),
        ),
      ),
      SizedBox(width: 40),
      ElevatedButton(
        onPressed: () async {
          var nm = addctrl.text.trim();
          var ph = int.tryParse(mobctrl.text.trim());
          var daily = int.tryParse(dailyctrl.text.trim());
          var id = uuid.v4();
          if (nm.isNotEmpty && ph != null && daily != null) {
            final data = Employee(id: id, name: nm, daily: daily, phone: ph);
            await ref.read(empcontrlprovider.notifier).addemp(batchid, data);
            Get.back();
          } else {
            Get.snackbar(
              'Opps !',
              "Don’t forget to add all details",
              colorText: Colors.white,
              isDismissible: false,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.only(bottom: 10),
              borderRadius: 0,
            );
          }
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF021B79),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),

        child: Text(
          "Save",
          style: AppFonts().heading.copyWith(color: Colors.white, fontSize: 14),
        ),
      ),
    ],
  );
}

void editempdilog(WidgetRef ref, String batchid, Employee emp) {
  TextEditingController addctrl = TextEditingController(text: emp.name);
  TextEditingController mobctrl = TextEditingController(
    text: emp.phone.toString(),
  );
  TextEditingController dailyctrl = TextEditingController(
    text: emp.daily.toString(),
  );
  final uuid = Uuid();
  Get.defaultDialog(
    backgroundColor: Colors.white,
    title: "Add Employee",
    titleStyle: AppFonts().heading.copyWith(color: Color(0xFF021B79)),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: addctrl,
            decoration: InputDecoration(
              hintText: "Enter Name",
              hintStyle: TextStyle(color: Colors.grey[500]),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFF0575E6)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            keyboardType: TextInputType.number,
            controller: mobctrl,
            decoration: InputDecoration(
              hintText: "Enter mobile",
              hintStyle: TextStyle(color: Colors.grey[500]),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFF0575E6)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            keyboardType: TextInputType.number,
            controller: dailyctrl,
            decoration: InputDecoration(
              hintText: "Enter daily amount",
              hintStyle: TextStyle(color: Colors.grey[500]),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFF0575E6)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () {
          Get.back();
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
        child: Text(
          "Cancel",
          style: AppFonts().heading.copyWith(
            color: Color(0xFF021B79),
            fontSize: 14,
          ),
        ),
      ),
      SizedBox(width: 40),
      ElevatedButton(
        onPressed: () async {
          var nm = addctrl.text.trim();
          var ph = int.tryParse(mobctrl.text.trim());
          var daily = int.tryParse(dailyctrl.text.trim());
          if (nm.isNotEmpty && ph != null && daily != null) {
            final data = Employee(
              id: emp.id,
              name: nm,
              daily: daily,
              phone: ph,
            );
            ref.read(empcontrlprovider.notifier).editemp(batchid, data);
            Get.back();
          } else {
            Get.snackbar(
              'Opps !',
              "Don’t forget to add all details",
              colorText: Colors.white,
              isDismissible: false,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.only(bottom: 10),
              borderRadius: 0,
            );
          }
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF021B79),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),

        child: Text(
          "Save",
          style: AppFonts().heading.copyWith(color: Colors.white, fontSize: 14),
        ),
      ),
    ],
  );
}

void deleteemp(WidgetRef ref, String batchid, Employee emp) {
  Get.defaultDialog(
    backgroundColor: Colors.white,
    title: "Delete Batch",
    titleStyle: AppFonts().heading.copyWith(color: Color(0xFF021B79)),
    middleText: "Are you sure you want to delete?",
    actions: [
      TextButton(
        onPressed: () {
          Get.back();
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
        child: Text(
          "Cancel",
          style: AppFonts().heading.copyWith(
            color: Color(0xFF021B79),
            fontSize: 14,
          ),
        ),
      ),
      SizedBox(width: 40),
      ElevatedButton(
        onPressed: () {
          ref.read(empcontrlprovider.notifier).deleteemp(batchid, emp.id);
          Get.back();

          Get.snackbar(
            'Success',
            "Deleted Successfully",
            colorText: Colors.white,
            isDismissible: false,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.only(bottom: 10),
            borderRadius: 0,
          );
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF021B79),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),

        child: Text(
          "Delete",
          style: AppFonts().heading.copyWith(color: Colors.white, fontSize: 14),
        ),
      ),
    ],
  );
}

void addpayment(
  WidgetRef ref,
  String batchId,
  String empId,
  String attendanceId,
  String status,
  int dailyRate,
) {
  TextEditingController pay_ctrl = TextEditingController();
  String selectdays = 'Half Day';
  double calculateAmount(String type, int dailyRate) {
    switch (type) {
      case "Full Day":
        return dailyRate * 1;
      case "Half Day":
        return dailyRate * 0.5;
      case "1.5 Day":
        return dailyRate * 1.5;
      default:
        return 0;
    }
  }

  Get.defaultDialog(
    backgroundColor: Colors.white,
    title: "Add Payment",
    titleStyle: AppFonts().heading.copyWith(color: Color(0xFF021B79)),
    content: StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: pay_ctrl,
                decoration: InputDecoration(
                  hintText: "Enter Paid Amt",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF0575E6)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: DropdownButtonFormField(
                items: ['Half Day', 'Full Day', '1.5 Day']
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: AppFonts().body.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectdays = value!;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Select Days",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
    actions: [
      TextButton(
        onPressed: () {
          Get.back();
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
        child: Text(
          "Cancel",
          style: AppFonts().heading.copyWith(
            color: Color(0xFF021B79),
            fontSize: 14,
          ),
        ),
      ),
      SizedBox(width: 40),
      ElevatedButton(
        onPressed: () async {
          final paid = int.tryParse(pay_ctrl.text.trim());
          if (paid == null) {
            Get.snackbar(
              "Error",
              "Please enter valid amount",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return;
          }
          try {
            final total = calculateAmount(selectdays, dailyRate);

            final attendance = Attendence(
              id: attendanceId,
              date: attendanceId.split("_")[0],
              status: status,
              type: selectdays,
              paid: paid,
              totalSalary: total.toInt(),
            );

            await ref
                .read(empcontrlprovider.notifier)
                .updateAttendance(
                  batchId: batchId,
                  empId: empId,
                  attendance: attendance,
                );

            Get.back();
            Get.snackbar(
              'Successfully !',
              "Add Data ",
              colorText: Colors.white,
              isDismissible: false,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.only(bottom: 10),
              borderRadius: 0,
            );
          } catch (e) {}
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF021B79),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),

        child: Text(
          "Save",
          style: AppFonts().heading.copyWith(color: Colors.white, fontSize: 14),
        ),
      ),
    ],
  );
}

bool isDateAllowed(DateTime date) {
  final today = DateTime.now();

  final d = DateTime(date.year, date.month, date.day);
  final t = DateTime(today.year, today.month, today.day);
  final y = t.subtract(Duration(days: 1));

  return d == t || d == y;
}

AttendanceSummary calculateSummary(List<AttendanceRow> list) {
  int presentDays = 0;
  int absentDays = 0;

  double totalSalary = 0;
  double paid = 0;

  for (var att in list) {
    if (att.status == "P") {
      presentDays++;
    } else {
      absentDays++;
    }

    totalSalary += att.totalSalary;
    paid += att.paid;
  }

  return AttendanceSummary(
    presentDays: presentDays,
    absentDays: absentDays,
    totalSalary: totalSalary,
    paid: paid,
    remaining: totalSalary - paid,
  );
}
