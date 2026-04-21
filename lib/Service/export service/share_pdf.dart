import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tutionsapp/model/attendece_table.dart';

class ExportService {
  static Future<File> exportAttendancePdf(List<AttendanceRow> list) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Table.fromTextArray(
            headers: ["Sr", "Date", "Payment", "Type", "Status"],
            data: List.generate(list.length, (index) {
              final e = list[index];
              return [index + 1, e.date, e.paid, e.type, e.status];
            }),
          );
        },
      ),
    );

    final dir = await getExternalStorageDirectory();
    final file = File("${dir!.path}/attendance.pdf");

    await file.writeAsBytes(await pdf.save(), flush: true);
    return file;
  }

  static Future<void> shareAttendance(List<AttendanceRow> list) async {
    final file = await exportAttendancePdf(list);

    if (!await file.exists()) return;

    await Share.shareXFiles([XFile(file.path)], text: "Attendance Report");
  }
}
