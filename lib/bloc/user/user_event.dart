
abstract class UserEvent  {
  const UserEvent();
}

class LoadUserProfile extends UserEvent {
  final String uid;
  const LoadUserProfile(this.uid);

  List<Object> get props => [uid];
}

class UpdateUserProfile extends UserEvent {
  final String name;
  final String gender;

  const UpdateUserProfile({required this.name, required this.gender});

  List<Object> get props => [name, gender];
}
