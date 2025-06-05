abstract class SignupState {
  const SignupState();

  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupFailure extends SignupState {
  final String error;
  const SignupFailure(this.error);

  @override
  List<Object> get props => [error];
}
