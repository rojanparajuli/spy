abstract class SignupEvent {
  const SignupEvent();
}

class SignupSubmitted extends SignupEvent {
  final String email;
  final String password;
  final String fullName;
  final String gender;
  final String phone;

  const SignupSubmitted({
    required this.email,
    required this.password,
    required this.fullName,
    required this.gender,
    required this.phone,
  });

  
  List<Object> get props => [email, password, fullName, gender, phone];
}
