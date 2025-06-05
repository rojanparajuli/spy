import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spy/repository/auth_repository.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository authRepository;

  SignupBloc(this.authRepository) : super(SignupInitial()) {
  on<SignupSubmitted>((event, emit) async {
  emit(SignupLoading());
  try {
    await authRepository.signUp(
      email: event.email,
      password: event.password,
      fullName: event.fullName,
      gender: event.gender,
      phone: event.phone,
    );
    emit(SignupSuccess());
  } catch (e) {
    emit(SignupFailure(e.toString()));
  }
});

  }
}
