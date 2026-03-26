package com.example.call_log_exporter

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.provider.CallLog
import android.provider.ContactsContract
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall

class MainActivity : FlutterActivity() {
    private val CHANNEL = "call_log_exporter/call_logs"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "requestPermissions" -> {
                    val granted = requestCallLogPermissions()
                    result.success(granted)
                }
                "getCallLogs" -> {
                    try {
                        val logs = getCallLogs(call.argument("startDate"))
                        result.success(logs)
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun requestCallLogPermissions(): Boolean {
        val permissions = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            arrayOf(
                Manifest.permission.READ_CALL_LOG,
                Manifest.permission.READ_CONTACTS,
                Manifest.permission.READ_PHONE_STATE
            )
        } else {
            arrayOf(
                Manifest.permission.READ_CALL_LOG,
                Manifest.permission.READ_CONTACTS
            )
        }

        return permissions.all { permission ->
            ContextCompat.checkSelfPermission(this, permission) == PackageManager.PERMISSION_GRANTED
        }
    }

    private fun getCallLogs(startDate: Long?): List<Map<String, Any?>> {
        val callLogs = mutableListOf<Map<String, Any?>>()

        try {
            val selection = if (startDate != null) {
                "${CallLog.Calls.DATE} >= ?"
            } else {
                null
            }

            val selectionArgs = if (startDate != null) {
                arrayOf(startDate.toString())
            } else {
                null
            }

            val cursor = contentResolver.query(
                CallLog.Calls.CONTENT_URI,
                null,
                selection,
                selectionArgs,
                "${CallLog.Calls.DATE} DESC"
            )

            cursor?.use { c ->
                val numberIndex = c.getColumnIndex(CallLog.Calls.NUMBER)
                val typeIndex = c.getColumnIndex(CallLog.Calls.TYPE)
                val dateIndex = c.getColumnIndex(CallLog.Calls.DATE)
                val durationIndex = c.getColumnIndex(CallLog.Calls.DURATION)

                val phoneNumber = c.getString(numberIndex) ?: ""
                val callType = when (c.getInt(typeIndex)) {
                    CallLog.Calls.INCOMING_TYPE -> "incoming"
                    CallLog.Calls.OUTGOING_TYPE -> "outgoing"
                    CallLog.Calls.MISSED_TYPE -> "missed"
                    CallLog.Calls.REJECTED_TYPE -> "rejected"
                    else -> "unknown"
                }
                val timestamp = c.getLong(dateIndex)
                val duration = c.getLong(durationIndex)
                val contactName = getContactName(phoneNumber)

                val callLog = mapOf(
                    "phoneNumber" to phoneNumber,
                    "contactName" to contactName,
                    "callType" to callType,
                    "timestamp" to timestamp,
                    "duration" to duration
                )

                callLogs.add(callLog)
            }
        } catch (e: Exception) {
            // Handle exception
        }

        return callLogs
    }

    private fun getContactName(phoneNumber: String): String? {
        return try {
            val uri = android.net.Uri.withAppendedPath(
                ContactsContract.PhoneLookup.CONTENT_FILTER_URI,
                android.net.Uri.encode(phoneNumber)
            )
            val projection = arrayOf(ContactsContract.PhoneLookup.DISPLAY_NAME)

            contentResolver.query(uri, projection, null, null, null)?.use { cursor ->
                if (cursor.moveToFirst()) {
                    val nameIndex = cursor.getColumnIndex(ContactsContract.PhoneLookup.DISPLAY_NAME)
                    return cursor.getString(nameIndex)
                } else {
                    null
                }
            }
        } catch (e: Exception) {
            null
        }
    }
}
