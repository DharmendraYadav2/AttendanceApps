import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:horizontal_weekly_calendar/weekly_calendar.dart';
import 'package:tutionsapp/Service/Firebase/controller/employee_ctrl.dart';
import 'package:tutionsapp/model/attendence_model.dart';
import 'package:tutionsapp/model/batch_model.dart';

import '../Functions/app_function.dart';
import '../Theme/app_fonts.dart';
import 'Attendence_report.dart';

class Individual_person extends ConsumerStatefulWidget {
  final String batchid;
  const Individual_person({super.key, required this.batchid});

  @override
  ConsumerState<Individual_person> createState() => _Individual_personState();
}

class _Individual_personState extends ConsumerState<Individual_person> {
  List<bool> ispresentlist = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(empcontrlprovider.notifier).loademp(widget.batchid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final emp = ref.watch(empcontrlprovider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0575E6), Color(0xFF021B79)],
            ),
          ),
        ),
        title: Text(
          "Hajri Book",
          style: AppFonts().heading.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              addempdilog(ref, widget.batchid);
            },
            icon: Icon(Icons.add, color: Colors.white, size: 40),
          ),
        ],
      ),
      bottomSheet: Container(
        height: MediaQuery.of(context).size.height / 9,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0575E6), Color(0xFF021B79)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    final empList = ref.read(empcontrlprovider).value ?? [];

                    Get.defaultDialog(
                      backgroundColor: Colors.white,
                      title: "Confirm Attendance",
                      middleText:
                          "Do you want to save attendance for all employees?",
                      textCancel: "No",
                      textConfirm: "Yes",
                      confirmTextColor: Colors.white,
                      buttonColor: Color(0xFF021B79),

                      onConfirm: () async {
                        Get.back();

                        for (int i = 0; i < empList.length; i++) {
                          final empData = empList[i];

                          final status = ispresentlist[i] ? "P" : "A";
                          String formatDate(DateTime date) {
                            return "${date.year.toString().padLeft(4, '0')}-"
                                "${date.month.toString().padLeft(2, '0')}-"
                                "${date.day.toString().padLeft(2, '0')}";
                          }

                          final formattedDate = formatDate(selectedDate);

                          final attendance = Attendence(
                            id: "${formattedDate}_${empData.id}",
                            date: formattedDate,
                            status: status,
                            paid: 0,
                            type: "Full Day",
                            totalSalary: status == "P" ? empData.daily : 0,
                          );

                          await ref
                              .read(empcontrlprovider.notifier)
                              .markAttendance(
                                batchId: widget.batchid,
                                empId: empData.id,
                                attendance: attendance,
                              );
                        }

                        Get.snackbar(
                          "Success",
                          "Attendance marked for all employees",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Confirm",
                        style: AppFonts().heading.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          SizedBox(height: 20),
          HorizontalWeeklyCalendar(
            initialDate: DateTime.now(),
            calendarStyle: HorizontalCalendarStyle(
              activeDayColor: Color(0xFF0575E6),
              dayNumberStyle: TextStyle(color: Colors.white),
              selectionAnimationCurve: Curves.bounceIn,
              selectedDayTextStyle: TextStyle(color: Colors.white),
              monthHeaderStyle: AppFonts().heading.copyWith(),
            ),
            onDateSelected: (date) {
              if (!isDateAllowed(date)) return;

              setState(() {
                selectedDate = date;
              });
            },
            selectedDate: selectedDate,
            onNextMonth: () {},
            onPreviousMonth: () {},
          ),

          SizedBox(height: 20),
          Expanded(
            child: emp.when(
              data: (emplist) {
                if (emplist.isEmpty) {
                  return Center(
                    child: Text(
                      "No Employee created yet",
                      style: AppFonts().heading,
                    ),
                  );
                }
                if (ispresentlist.length != emplist.length) {
                  ispresentlist = List.generate(emplist.length, (_) => true);
                }
                return Padding(
                  padding: EdgeInsets.only(bottom: 90),
                  child: ListView.builder(
                    itemCount: emplist.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        endActionPane: ActionPane(
                          key: ValueKey(emplist[index].id),
                          motion: DrawerMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                editempdilog(
                                  ref,
                                  widget.batchid,
                                  emplist[index],
                                );
                              },
                              icon: Icons.edit_outlined,
                              label: "Edit",
                              backgroundColor: Color(0xFF0575E6),
                              foregroundColor: Colors.white,
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                deleteemp(ref, widget.batchid, emplist[index]);
                              },
                              icon: Icons.delete,
                              label: "Delete",
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ],
                        ),

                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            elevation: 0.6,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(12),
                            ),

                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                child: Icon(
                                  Icons.person,
                                  color: Color(0xFF021B79),
                                ),
                              ),
                              title: Text(
                                emplist[index].name,
                                style: AppFonts().heading.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.call,
                                    color: Colors.black38,
                                    size: 15,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "${emplist[index].phone}",
                                    style: AppFonts().body.copyWith(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Get.to(
                                        () => View_attendence(
                                          batchId: widget.batchid,
                                          empId: emplist[index].id,
                                          empName: emplist[index].name,
                                          phone: emplist[index].phone,
                                          dailyRate: emplist[index].daily,
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.remove_red_eye_outlined,
                                      size: 40,
                                      color: Color(0xFF021B79),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        ispresentlist[index] =
                                            !ispresentlist[index];
                                      });
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(12),
                                        color: ispresentlist[index]
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      child: Center(
                                        child: Text(
                                          ispresentlist[index] ? "P" : "A",
                                          style: AppFonts().heading.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                final empData = emplist[index];

                                String formatDate(DateTime date) {
                                  return "${date.year.toString().padLeft(4, '0')}-"
                                      "${date.month.toString().padLeft(2, '0')}-"
                                      "${date.day.toString().padLeft(2, '0')}";
                                }

                                final formattedDate = formatDate(selectedDate);

                                final attendanceId =
                                    "${formattedDate}_${empData.id}";

                                final status = ispresentlist[index] ? "P" : "A";
                                addpayment(
                                  ref,
                                  widget.batchid,
                                  empData.id,
                                  attendanceId,
                                  status,
                                  empData.daily,
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              error: (e, _) => Center(child: Text(e.toString())),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
