import 'dart:async';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/call_log_entry.dart';

class CallLogService {
  static const MethodChannel _channel = MethodChannel('call_log_exporter/call_logs');

  static Future<bool> requestPermissions() async {
    try {
      final bool granted = await _channel.invokeMethod('requestPermissions');
      return granted;
    } catch (e) {
      return false;
    }
  }

  static Future<List<CallLogEntry>> getCallLogs({DateTime? startDate}) async {
    try {
      final hasPermissions = await requestPermissions();
      if (!hasPermissions) {
        throw Exception('Call log and contacts permissions are required');
      }

      final List<dynamic> result = await _channel.invokeMethod('getCallLogs', {
        'startDate': startDate?.millisecondsSinceEpoch,
      });

      return result.map((item) => CallLogEntry(
        phoneNumber: item['phoneNumber'] ?? '',
        contactName: item['contactName'],
        callType: item['callType'] ?? 'unknown',
        timestamp: DateTime.fromMillisecondsSinceEpoch(item['timestamp'] ?? 0),
        duration: item['duration'] ?? 0,
      )).toList();
    } catch (e) {
      throw Exception('Failed to get call logs: $e');
    }
  }

  static Future<List<CallLogEntry>> getLast30DaysCallLogs() async {
    final startDate = DateTime.now().subtract(const Duration(days: 30));
    return getCallLogs(startDate: startDate);
  }
}
