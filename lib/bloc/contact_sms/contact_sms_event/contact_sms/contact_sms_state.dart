abstract class ContactSmsState {}

class ContactSmsInitial extends ContactSmsState {}

class ContactSmsLoading extends ContactSmsState {}

class ContactSmsUploaded extends ContactSmsState {}

class ContactSmsError extends ContactSmsState {
  final String message;
  ContactSmsError(this.message);
}
