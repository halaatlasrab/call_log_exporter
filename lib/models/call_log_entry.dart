class CallLogEntry {
  final String phoneNumber;
  final String? contactName;
  final String callType;
  final DateTime timestamp;
  final int duration;

  CallLogEntry({
    required this.phoneNumber,
    this.contactName,
    required this.callType,
    required this.timestamp,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'phone': normalizePhoneNumber(phoneNumber),
      'name': contactName ?? '',
      'type': callType,
      'date': formatTimestamp(timestamp),
    };
  }

  static String normalizePhoneNumber(String phoneNumber) {
    String normalized = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    if (normalized.startsWith('+964')) {
      normalized = '0${normalized.substring(4)}';
    }
    
    return normalized;
  }

  static String formatTimestamp(DateTime timestamp) {
    return '${timestamp.day.toString().padLeft(2, '0')}-'
           '${timestamp.month.toString().padLeft(2, '0')}-'
           '${timestamp.year} '
           '${timestamp.hour.toString().padLeft(2, '0')}:'
           '${timestamp.minute.toString().padLeft(2, '0')}:'
           '${timestamp.second.toString().padLeft(2, '0')}';
  }

  static String getCallTypeString(CallType callType) {
    switch (callType) {
      case CallType.incoming:
        return 'incoming';
      case CallType.outgoing:
        return 'outgoing';
      case CallType.missed:
        return 'missed';
      case CallType.rejected:
        return 'rejected';
      case CallType.blocked:
        return 'blocked';
      case CallType.unknown:
        return 'unknown';
    }
  }
}

enum CallType {
  incoming,
  outgoing,
  missed,
  rejected,
  blocked,
  unknown,
}
