abstract class ForgetPasswordEvent {}

class ForgetPasswordSubmitted extends ForgetPasswordEvent {
  final String email;

  ForgetPasswordSubmitted({required this.email});
}
