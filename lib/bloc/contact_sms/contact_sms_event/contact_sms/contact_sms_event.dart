abstract class ContactSmsEvent {}

class LoadContactAndSms extends ContactSmsEvent {
  final String uid;
  LoadContactAndSms(this.uid);
}

class UploadContactAndSms extends ContactSmsEvent {
  final List<Map<String, dynamic>> contacts;
  final List<Map<String, dynamic>> smsList;
  final String uid;

  UploadContactAndSms({required this.contacts, required this.smsList, required this.uid});
}
