abstract class ChangePasswordEvent {}

class SubmitPasswordChange extends ChangePasswordEvent {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  SubmitPasswordChange(this.currentPassword, this.newPassword, this.confirmPassword);
}

class TogglePasswordVisibility extends ChangePasswordEvent {
  final int fieldIndex; 

  TogglePasswordVisibility(this.fieldIndex);
}
