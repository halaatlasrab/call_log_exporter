import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import '../models/call_log_entry.dart';

class CallLogService {
  static Future<bool> requestPermissions() async {
    final phonePermission = await Permission.phone.request();
    final contactsPermission = await Permission.contacts.request();
    
    return phonePermission.isGranted && contactsPermission.isGranted;
  }

  static Future<List<CallLogEntry>> getCallLogs({DateTime? startDate}) async {
    try {
      final hasPermissions = await requestPermissions();
      if (!hasPermissions) {
        throw Exception('Call log and contacts permissions are required');
      }

      // For demo purposes, return sample data
      // In a real app, you would implement platform-specific call log reading
      final List<CallLogEntry> sampleLogs = [
        CallLogEntry(
          phoneNumber: '+9647801234567',
          contactName: 'John Doe',
          callType: 'incoming',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          duration: 120,
        ),
        CallLogEntry(
          phoneNumber: '+9647801234568',
          contactName: 'Jane Smith',
          callType: 'outgoing',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          duration: 300,
        ),
        CallLogEntry(
          phoneNumber: '+9647801234569',
          contactName: null,
          callType: 'missed',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          duration: 0,
        ),
      ];

      // Filter by date if needed
      if (startDate != null) {
        return sampleLogs.where((log) => log.timestamp.isAfter(startDate)).toList();
      }

      return sampleLogs;
    } catch (e) {
      throw Exception('Failed to get call logs: $e');
    }
  }

  static Future<List<CallLogEntry>> getLast30DaysCallLogs() async {
    final startDate = DateTime.now().subtract(const Duration(days: 30));
    return getCallLogs(startDate: startDate);
  }
}
