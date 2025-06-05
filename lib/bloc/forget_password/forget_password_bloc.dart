import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forget_password_event.dart';
import 'forget_password_state.dart';

class ForgetPasswordBloc extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ForgetPasswordBloc() : super(ForgetPasswordInitial()) {
    on<ForgetPasswordSubmitted>((event, emit) async {
      emit(ForgetPasswordLoading());
      try {
        await _auth.sendPasswordResetEmail(email: event.email);
        emit(ForgetPasswordSuccess());
      } catch (e) {
        emit(ForgetPasswordFailure(e.toString()));
      }
    });
  }
}
