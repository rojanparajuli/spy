abstract class LoginEvent {
  const LoginEvent();
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitted(this.email, this.password);

  List<Object> get props => [email, password];
}

class GoogleLoginRequested extends LoginEvent {}