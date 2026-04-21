import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:horizontal_weekly_calendar/weekly_calendar.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tutionsapp/Functions/app_function.dart';
import 'package:tutionsapp/model/employee_model.dart';

import '../Service/Firebase/controller/attendence_pr.dart';
import '../Service/Firebase/providers/att_list.dart';
import '../Service/export service/share_pdf.dart';
import '../Theme/app_fonts.dart';
import '../model/attendece_table.dart';
import '../model/attendence_filter.dart';

class View_attendence extends ConsumerStatefulWidget {
  final String batchId;
  final String empId;
  final String empName;
  final int phone;
  final int dailyRate;
  View_attendence({
    required this.batchId,
    required this.empId,
    required this.empName,
    required this.phone,
    required this.dailyRate,
  });
  @override
  ConsumerState<View_attendence> createState() => _View_attendenceState();
}

class _View_attendenceState extends ConsumerState<View_attendence> {
  DateTime selectedMonth = DateTime.now();
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.invalidate(
        attendanceListProvider(
          AttendanceFilter(
            batchId: widget.batchId,
            empId: widget.empId,
            month: selectedMonth.month,
            year: selectedMonth.year,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String getMonthYear(DateTime date) {
      const months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];
      return "${months[date.month - 1]} ${date.year}";
    }

    final listAsync = ref.watch(
      attendanceListProvider(
        AttendanceFilter(
          batchId: widget.batchId,
          empId: widget.empId,
          month: selectedMonth.month,
          year: selectedMonth.year,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF0575E6),
        onPressed: () async {
          try {
            final data = listAsync.maybeWhen(
              data: (value) => value,
              orElse: () => <AttendanceRow>[],
            );

            print("DATA LENGTH: ${data.length}");

            final file = await ExportService.exportAttendancePdf(data);

            print("FILE PATH: ${file.path}");

            await ExportService.shareAttendance(data);
          } catch (e) {
            print("ERROR: $e");
          }
        },
        child: Icon(Icons.share, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: MediaQuery.of(context).size.height / 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFF021B79), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Name:${widget.empName}",
                        style: AppFonts().heading.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mob:${widget.phone}",
                            style: AppFonts().heading.copyWith(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          Text(
                            "Month: ${getMonthYear(selectedMonth)}",
                            style: AppFonts().heading.copyWith(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(8.0), child: Divider()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Total",
                              style: AppFonts().heading.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Paid",
                              style: AppFonts().heading.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Remaining",
                              style: AppFonts().heading.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    listAsync.when(
                      data: (list) {
                        final summary = calculateSummary(list);
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "₹ ${summary.totalSalary.toInt()}",
                                  style: AppFonts().heading.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "₹${summary.paid.toInt()}",
                                  style: AppFonts().heading.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "₹${summary.remaining.toInt()}",
                                  style: AppFonts().heading.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      error: (e, _) => Text("Error: $e"),
                      loading: () => Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),
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
                final newMonth = DateTime(date.year, date.month, 1);

                if (newMonth != selectedMonth) {
                  setState(() {
                    selectedMonth = newMonth;
                  });
                }
              },

              onNextMonth: () {
                setState(() {
                  selectedMonth = DateTime(
                    selectedMonth.year,
                    selectedMonth.month + 1,
                    1,
                  );
                });
              },

              onPreviousMonth: () {
                setState(() {
                  selectedMonth = DateTime(
                    selectedMonth.year,
                    selectedMonth.month - 1,
                    1,
                  );
                });
              },

              selectedDate: selectedMonth,
            ),
            SizedBox(height: 10),

            listAsync.when(
              data: (list) {
                return SfDataGrid(
                  source: AttendanceDataSource(list),
                  columns: [
                    GridColumn(
                      columnName: 'srno',
                      label: Container(
                        color: Color(0xFF0575E6),
                        alignment: Alignment.center,
                        child: Text(
                          "Srno",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'date',
                      label: Container(
                        color: Color(0xFF0575E6),
                        alignment: Alignment.center,
                        child: Text(
                          "Date",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'payment',
                      label: Container(
                        color: Color(0xFF0575E6),
                        alignment: Alignment.center,
                        child: Text(
                          "Payment",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'type',
                      label: Container(
                        color: Color(0xFF0575E6),
                        alignment: Alignment.center,
                        child: Text(
                          "Type",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'attendance',
                      label: Container(
                        color: Color(0xFF0575E6),
                        alignment: Alignment.center,
                        child: Text(
                          "Status",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => CircularProgressIndicator(color: Colors.blue),
              error: (e, _) => Text("Error: $e"),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceDataSource extends DataGridSource {
  AttendanceDataSource(this.rowsData);

  final List<AttendanceRow> rowsData;

  @override
  List<DataGridRow> get rows => rowsData.map((e) {
    return DataGridRow(
      cells: [
        DataGridCell(columnName: 'srno', value: rowsData.indexOf(e) + 1),
        DataGridCell(columnName: 'date', value: e.date),
        DataGridCell(columnName: 'payment', value: e.paid),
        DataGridCell(columnName: 'type', value: e.type),
        DataGridCell(columnName: 'attendance', value: e.status),
      ],
    );
  }).toList();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map((cell) {
        return Container(
          alignment: Alignment.center,
          child: Text(cell.value.toString()),
        );
      }).toList(),
    );
  }
}
