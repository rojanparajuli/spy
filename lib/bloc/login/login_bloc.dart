import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spy/bloc/google/google_login_bloc.dart';
import 'package:spy/repository/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  final GoogleLogin googleLogin; 

  LoginBloc(this.authRepository, this.googleLogin) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        await authRepository.logIn(
          email: event.email,
          password: event.password,
        );
        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });

    // Add this handler for Google login
    on<GoogleLoginRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        await googleLogin.signInWithGoogle();
        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
  }
}