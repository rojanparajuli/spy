import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'data_event.dart';
import 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  final FirebaseFirestore firestore;

  DataBloc(this.firestore) : super(DataInitial()) {
    on<FetchUserData>(_onFetchUserData);
  }

  Future<void> _onFetchUserData(
    FetchUserData event,
    Emitter<DataState> emit,
  ) async {
    emit(DataLoading());
    try {
      final smsSnapshot = await firestore
          .collection('users')
          .doc(event.userId)
          .collection('sms')
          .get();
      final contactsSnapshot = await firestore
          .collection('users')
          .doc(event.userId)
          .collection('contacts')
          .get();

      final sms = smsSnapshot.docs.map((doc) => doc.data()).toList();
      final contacts = contactsSnapshot.docs.map((doc) => doc.data()).toList();

      emit(DataLoaded(contacts: contacts, sms: sms));
    } catch (e) {
      emit(DataError(e.toString()));
    }
  }
}
