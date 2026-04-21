import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tutionsapp/model/attendece_table.dart';

class ExportService {
  static Future<pw.Font> _loadFont() async {
    final fontData = await rootBundle.load("assets/fonts/Exo2-Medium.ttf");
    return pw.Font.ttf(fontData);
  }

  static Future<File> exportAttendancePdf(List<AttendanceRow> list) async {
    final pdf = pw.Document();

    final font = await _loadFont();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Attendance Report",
                style: pw.TextStyle(
                  font: font,
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),

              pw.Table.fromTextArray(
                headers: ["Sr", "Date", "Payment", "Type", "Status"],
                data: List.generate(list.length, (index) {
                  final e = list[index];
                  return [
                    "${index + 1}",
                    e.date.toString(),
                    "₹ ${e.paid}",
                    e.type.toString(),
                    e.status.toString(),
                  ];
                }),

                headerStyle: pw.TextStyle(
                  font: font,
                  fontWeight: pw.FontWeight.bold,
                ),

                cellStyle: pw.TextStyle(font: font),
              ),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/attendance.pdf");

    await file.writeAsBytes(await pdf.save(), flush: true);

    return file;
  }

  static Future<void> shareAttendance(List<AttendanceRow> list) async {
    try {
      final file = await exportAttendancePdf(list);

      if (!await file.exists()) {
        print("File not found!");
        return;
      }

      await Share.shareXFiles([XFile(file.path)], text: "Attendance Report");
    } catch (e) {
      print("ERROR: $e");
    }
  }
}
