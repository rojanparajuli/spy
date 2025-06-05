abstract class DataEvent {}

class FetchUserData extends DataEvent {
  final String userId;
  FetchUserData(this.userId);
}
