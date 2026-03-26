import 'dart:async';
import 'package:call_log/call_log.dart' as call_log;
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/call_log_entry.dart';

class CallLogService {
  static Future<bool> requestPermissions() async {
    final callLogPermission = await Permission.phone.request();
    final contactsPermission = await Permission.contacts.request();
    
    return callLogPermission.isGranted && contactsPermission.isGranted;
  }

  static Future<List<CallLogEntry>> getCallLogs({DateTime? startDate}) async {
    try {
      final hasPermissions = await requestPermissions();
      if (!hasPermissions) {
        throw Exception('Call log and contacts permissions are required');
      }

      final Iterable<call_log.CallLogEntry> callLogs = await call_log.CallLog.get();
      final contacts = await ContactsService.getContacts(withThumbnails: false);
      
      final contactMap = <String, String>{};
      for (final contact in contacts) {
        if (contact.phones != null) {
          for (final phone in contact.phones!) {
            if (phone.value != null) {
              final normalizedPhone = CallLogEntry.normalizePhoneNumber(phone.value!);
              contactMap[normalizedPhone] = contact.displayName ?? '';
            }
          }
        }
      }

      final List<CallLogEntry> processedLogs = [];
      final phoneMap = <String, CallLogEntry>{};

      for (final callLog in callLogs) {
        if (callLog.number == null || callLog.number!.isEmpty) continue;

        final normalizedPhone = CallLogEntry.normalizePhoneNumber(callLog.number!);
        final contactName = contactMap[normalizedPhone] ?? '';
        
        final entry = CallLogEntry(
          phoneNumber: callLog.number!,
          contactName: contactName,
          callType: _getCallTypeString(callLog.callType ?? call_log.CallType.unknown),
          timestamp: DateTime.fromMillisecondsSinceEpoch(callLog.timestamp ?? 0),
          duration: callLog.duration ?? 0,
        );

        if (startDate == null || entry.timestamp.isAfter(startDate)) {
          phoneMap[normalizedPhone] = entry;
        }
      }

      processedLogs.addAll(phoneMap.values);
      processedLogs.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return processedLogs;
    } catch (e) {
      throw Exception('Failed to get call logs: $e');
    }
  }

  static String _getCallTypeString(call_log.CallType callType) {
    switch (callType) {
      case call_log.CallType.incoming:
        return 'incoming';
      case call_log.CallType.outgoing:
        return 'outgoing';
      case call_log.CallType.missed:
        return 'missed';
      case call_log.CallType.rejected:
        return 'rejected';
      case call_log.CallType.blocked:
        return 'blocked';
      case call_log.CallType.voiceMail:
        return 'voicemail';
      case call_log.CallType.unknown:
      default:
        return 'unknown';
    }
  }

  static Future<List<CallLogEntry>> getLast30DaysCallLogs() async {
    final startDate = DateTime.now().subtract(const Duration(days: 30));
    return getCallLogs(startDate: startDate);
  }
}
