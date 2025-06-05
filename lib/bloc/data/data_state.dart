abstract class DataState {}

class DataInitial extends DataState {}

class DataLoading extends DataState {}

class DataLoaded extends DataState {
  final List<dynamic> contacts;
  final List<dynamic> sms;

  DataLoaded({required this.contacts, required this.sms});
}

class DataError extends DataState {
  final String message;
  DataError(this.message);
}
