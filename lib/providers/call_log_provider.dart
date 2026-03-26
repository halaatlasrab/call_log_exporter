import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/call_log_entry.dart';
import '../services/call_log_service_platform.dart';
import '../services/csv_export_service.dart';

class CallLogProvider extends ChangeNotifier {
  List<CallLogEntry> _callLogs = [];
  bool _isLoading = false;
  String? _error;
  File? _exportedFile;
  bool _useLast30DaysFilter = false;

  List<CallLogEntry> get callLogs => _callLogs;
  bool get isLoading => _isLoading;
  String? get error => _error;
  File? get exportedFile => _exportedFile;
  bool get useLast30DaysFilter => _useLast30DaysFilter;
  int get callLogCount => _callLogs.length;

  void toggleFilter() {
    _useLast30DaysFilter = !_useLast30DaysFilter;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    _error = null;
    notifyListeners();
  }

  void setError(String error) {
    _isLoading = false;
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> loadCallLogs() async {
    try {
      setLoading(true);
      
      if (_useLast30DaysFilter) {
        _callLogs = await CallLogService.getLast30DaysCallLogs();
      } else {
        _callLogs = await CallLogService.getCallLogs();
      }
      
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      setLoading(false);
    }
  }

  Future<void> exportToCsv() async {
    try {
      if (_callLogs.isEmpty) {
        setError('No call logs to export');
        return;
      }

      setLoading(true);
      _exportedFile = await CsvExportService.exportToCsv(_callLogs);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      setLoading(false);
    }
  }

  Future<void> shareFile() async {
    try {
      if (_exportedFile == null) {
        setError('No file to share. Please export first.');
        return;
      }

      setLoading(true);
      await CsvExportService.shareFile(_exportedFile!);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      setLoading(false);
    }
  }

  Future<void> exportAndShare() async {
    try {
      if (_callLogs.isEmpty) {
        setError('No call logs to export');
        return;
      }

      setLoading(true);
      _exportedFile = await CsvExportService.exportAndShare(_callLogs);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      setLoading(false);
    }
  }

  void clearCallLogs() {
    _callLogs.clear();
    _exportedFile = null;
    notifyListeners();
  }
}
