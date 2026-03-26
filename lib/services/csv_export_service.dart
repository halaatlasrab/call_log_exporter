import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import '../models/call_log_entry.dart';

class CsvExportService {
  static const String _fileName = 'call_log_export.csv';

  static Future<File> exportToCsv(List<CallLogEntry> callLogs) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');

      List<List<dynamic>> rows = [];
      
      rows.add(['phone', 'name', 'type', 'date']);

      for (final callLog in callLogs) {
        final map = callLog.toMap();
        rows.add([
          map['phone'],
          map['name'],
          map['type'],
          map['date'],
        ]);
      }

      String csv = const ListToCsvConverter().convert(rows);
      await file.writeAsString(csv);

      return file;
    } catch (e) {
      throw Exception('Failed to export CSV: $e');
    }
  }

  static Future<void> shareFile(File file) async {
    try {
      await Share.shareXFiles([XFile(file.path)], text: 'Call Log Export');
    } catch (e) {
      throw Exception('Failed to share file: $e');
    }
  }

  static Future<File> exportAndShare(List<CallLogEntry> callLogs) async {
    final file = await exportToCsv(callLogs);
    await shareFile(file);
    return file;
  }

  static Future<bool> fileExists() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  static Future<File?> getExportedFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');
      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
